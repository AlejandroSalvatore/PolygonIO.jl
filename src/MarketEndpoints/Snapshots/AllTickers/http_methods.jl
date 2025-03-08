struct TickersSnapshotResponse
    count::Union{Int64, Nothing}
    status::Union{String, Nothing}
    tickers::Union{Vector{TickerSnapshot}, Nothing}
    request_id::Union{String, Nothing}
end

function TickersSnapshotResponse(d::Dict{String, Any})
    count = get(d, "count", nothing)
    status = get(d, "status", nothing)
    tickers = "tickers" in keys(d) ? TickerSnapshot.(d["tickers"]) : nothing
    request_id = get(d, "request_id", nothing)
    return TickersSnapshotResponse(
        count,
        status,
        tickers,
        request_id
    )
end

function parse_tickers(tickers::Union{Vector{String}, String, Nothing})
    if tickers isa Vector{String}
        return join(tickers, ",")
    elseif tickers isa String
        tickers = split(tickers, ",")
        tickers = ticker .|> strip
        tickers = filter(ticker -> ticker != "", tickers)
        return join(tickers, ",")
    else
        return nothing
    end
end

function tickers_snapshot_query(
    tickers::Union{Vector{String}, String, Nothing} = nothing,
    include_otc::Union{Bool, Nothing} = false,
    )
    query = Dict()
    tickers = parse_tickers(tickers)
    tickers !== nothing ? query["tickers"] = tickers : nothing
    include_otc !== nothing ? query["include_otc"] = include_otc : nothing
    return query
end

function get_raw_tickers_snapshot(
    creds::Credentials;
    tickers::Union{Vector{String}, String, Nothing}=nothing,
    include_otc::Union{Bool, Nothing}=false
    )
    query = tickers_snapshot_query(tickers, include_otc)
    r = HTTP.get(join([endpoint(creds), "v2", "snapshot", "locale", "us", "markets", "stocks", "tickers"], '/'), headers = header(creds), query = query)
    return r
end

function DataFrames.DataFrame(all_tickers::TickersSnapshotResponse, except_fields::Vector{String}=["tickers"])
    df = DataFrame(all_tickers.tickers)
    for field in fieldnames(TickersSnapshotResponse)
        if !(String(field) in except_fields)
            metadata!(df, String(field), getproperty(all_tickers, field))
        end
    end
    return df
end

function TickersSnapshotResponse(raw_response::HTTP.Response)
    json_response = Parser.parse(String(raw_response.body))
    return TickersSnapshotResponse(json_response)
end

function tickers_snapshot(
    creds::Credentials;
    tickers::Union{Vector{String}, String, Nothing}=nothing,
    include_otc::Union{Bool, Nothing}=false
    )

    raw_tickers = get_raw_tickers_snapshot(creds; tickers, include_otc)

    if creds.content_type === "text/csv"
        return DataFrame(raw_tickers)
    elseif creds.content_type == "application/json"
        return TickersSnapshotResponse(raw_tickers)
    end

end
