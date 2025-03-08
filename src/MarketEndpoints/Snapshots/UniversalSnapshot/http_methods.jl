struct UniversalSnapshotResponse
    next_url::Union{String, Nothing}
    request_id::Union{String, Nothing}
    results::Union{Vector{UniversalSnapshot}, Nothing}
    status::Union{String, Nothing}
end

function UniversalSnapshotResponse(d::Dict{String, Any})

    next_url = get(d, "next_url", nothing)
    request_id = get(d, "request_id", nothing)
    results = "results" in keys(d) ? UniversalSnapshot.(d["results"]) : nothing
    status = get(d, "status", nothing)
    
    return UniversalSnapshotResponse(
        next_url,
        request_id,
        results,
        status
    )

end

function universal_snapshot_query(
    order::Union{String, Nothing},
    limit::Union{Int64, Nothing},
    sort::Union{String, Nothing},
    ticker::Union{String, Nothing}
    )

    query = Dict()
    
    order === nothing ? nothing : query["order"] = order
    limit === nothing ? nothing : query["limit"] = limit
    sort === nothing ? nothing : query["sort"] = sort
    ticker === nothing ? nothing : query["ticker"] = ticker

    return query 

end

function get_raw_universal_snapshot(
    creds::Credentials;
    order::Union{String, Nothing},
    limit::Union{Int64, Nothing},
    sort::Union{String, Nothing},
    ticker::Union{String, Nothing}
    )

    query = universal_snapshot_query(order, limit, sort, ticker)

    return HTTP.get(join([endpoint(creds), "v3", "snapshot"], '/'), headers = header(creds), query = query)

end

# function DataFrames.DataFrame(universal_snapshot::UniversalSnapshotResponse, except_fields::Vector{String}=["tickers"])

#     df = DataFrame(gainers_losers.tickers)
#     for field in fieldnames(GainersLosersResponse)
#         if !(String(field) in except_fields)
#             metadata!(df, String(field), getproperty(gainers_losers, field))
#         end
#     end

#     return df

# end

function UniversalSnapshotResponse(raw_response::HTTP.Response)

    json_response = Parser.parse(String(raw_response.body))

    return UniversalSnapshotResponse(json_response)
    
end

function universal_snapshot(
    creds::Credentials;
    order::Union{String, Nothing} = nothing,
    limit::Union{Int64, Nothing} = nothing,
    sort::Union{String, Nothing} = nothing,
    ticker::Union{String, Nothing} = nothing
    )

    raw_snap = get_raw_universal_snapshot(creds; order=order, limit=limit, sort=sort, ticker=ticker)

    if creds.content_type === "text/csv"
        @warn "This endpoint does not support 'text/csv'. Defaulting to 'application/json'"
        return UniversalSnapshotResponse(raw_snap)
    elseif creds.content_type == "application/json"
        return UniversalSnapshotResponse(raw_snap)
    end

end