struct TradesResponse
    next_url::Union{String, Nothing}
    results::Union{Vector{Trade}, Nothing}
    status::Union{String, Nothing}
    request_id::Union{String, Nothing}
end

function TradesResponse(d::Dict{String, Any})
    next_url = get(d, "next_url", nothing)
    results = "results" in keys(d) ? Trade.(d["results"]) : nothing
    status = get(d, "status", nothing)
    request_id = get(d, "request_id", nothing)
    return TradesResponse(
        next_url,
        results,
        status,
        request_id
    )
end

function trades_query(
    timestamp::Union{String, Int64, Date, Nothing} = nothing,
    order::Union{Symbol, String, Nothing} = "asc",
    limit::Union{Int64, Nothing} = 5000,
    sort::Union{Symbol, String, Nothing} = "timestamp"
    )

    query = Dict()
    timestamp === nothing ? nothing : query["timestamp"] = timestamp
    order === nothing ? nothing : query["order"] = order
    limit === nothing ? nothing : query["limit"] = limit
    sort === nothing ? nothing : query["sort"] = sort
    return query
end

function get_raw_trades(
    creds::Credentials,
    ticker::String;
    timestamp::Union{String, Int64, Date, Nothing} = nothing,
    order::Union{Symbol, String, Nothing} = "asc",
    limit::Union{Int64, Nothing} = 5000,
    sort::Union{Symbol, String, Nothing} = "timestamp"
    )::HTTP.Response

    query = trades_query(timestamp, order, limit, sort)
    r = HTTP.get(join([endpoint(creds), "v3", "trades", "$(ticker)"], '/'), query=query, headers = header(creds))
    return r
end

function TradesResponse(raw_response::HTTP.Response)
    json_response = Parser.parse(String(raw_response.body))
    return TradesResponse(json_response)
end

function DataFrames.DataFrame(trades::TradesResponse, except_fields::Vector{String}=["results"])
    df = DataFrame(trades.results)
    for field in fieldnames(TradesResponse)
        if !(String(field) in except_fields)
            metadata!(df, String(field), getproperty(trades, field))
        end
    end
    return df
end

    # results = response["results"]
    # while "next_url" in keys(response)
    #     next_url = response["next_url"]
    #     r = HTTP.get(next_url, headers = header(c))
    #     response = JSON.parse(String(r.body))
    #     results_next = response["results"]
    #     append!(results, results_next)
    # end
    # return _Trade.(results)


function trades(
    creds::Credentials,
    ticker::String;
    timestamp::Union{String, Int64, Date, Nothing} = nothing,
    order::Union{Symbol, String, Nothing} = "asc",
    limit::Union{Int64, Nothing} = 5000,
    sort::Union{Symbol, String, Nothing} = "timestamp"
    )::Union{TradesResponse, DataFrame}

    raw_trades = get_raw_trades(
        creds,
        ticker;
        timestamp,
        order,
        limit,
        sort
    )

    if creds.content_type === "text/csv"
        return DataFrame(raw_trades)
    elseif creds.content_type == "application/json"
        return TradesResponse(raw_trades)
    end
end