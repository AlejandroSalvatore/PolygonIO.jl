struct AggregatesResponse
    adjusted::Bool
    next_url::Union{String, Nothing}
    query_count::Int64
    request_id::String
    results::Union{Vector{AggregatedBar}, Nothing}
    results_count::Union{Int64, Nothing}
    status::String
    ticker::String
end

function AggregatesResponse(d::Dict{String, Any})
    adjusted = get(d, "adjusted", true)
    next_url = get(d, "next_url", nothing)
    query_count = d["queryCount"]
    request_id = d["request_id"]
    results = "results" in keys(d) ? AggregatedBar.(d["results"]) : nothing
    results_count = get(d, "resultsCount", nothing)
    status = d["status"]
    ticker = d["ticker"]
    return AggregatesResponse(
        adjusted,
        next_url,
        query_count,
        request_id,
        results,
        results_count,
        status,
        ticker
    )
end

function aggregates_query(
    adjusted::Bool = true,
    sort::String = "asc",
    limit::Int64 = 5000,
    )::Dict{String, Union{Bool, String, Int64}}
    return Dict(
        "adjusted" => string(adjusted),
        "sort" => string(sort),
        "limit" => string(limit),
    )
end

function get_raw_aggregates(
    creds::         Credentials, 
    ticker::        String, 
    multiplier::    Int64, 
    timespan::      Union{AggregatesTimespan, String, Symbol}, 
    from::          Union{Date, String}, 
    to::            Union{Date, String};
    adjusted::      Bool = true,
    sort::          Union{AggregatesSort, Symbol, String} = "asc",
    limit::         Int64 = 5000,
    )::HTTP.Response

    sort_str = parse_aggregates_sort(sort)
    query = aggregates_query(adjusted, sort_str, limit)

    timespan_str = parse_aggregates_timespan(timespan)
    r = HTTP.get(join([endpoint(creds), "v2","aggs", "ticker", HTTP.URIs.escapeuri(string(ticker)), "range", 
    HTTP.URIs.escapeuri(string(multiplier)), HTTP.URIs.escapeuri(timespan_str), HTTP.URIs.escapeuri(string(from)),
    HTTP.URIs.escapeuri(string(to))], '/'), headers = header(creds), query = query)
    # TODO: Implement next_url navigation
    return r

end

function AggregatesResponse(raw_response::HTTP.Response)
    json_response = Parser.parse(String(raw_response.body))
    return AggregatesResponse(json_response)
end

function DataFrames.DataFrame(aggregates::AggregatesResponse, except_fields::Vector{String}=["results"])
    df = DataFrame(aggregates.results)
    for field in fieldnames(AggregatesResponse)
        if !(String(field) in except_fields)
            metadata!(df, String(field), getproperty(aggregates, field))
        end
    end
    return df
end

function aggregates(
    creds::         Credentials, 
    ticker::        String, 
    multiplier::    Int64, 
    timespan::      Union{AggregatesTimespan, Symbol, String}, 
    from::          Union{Date, String}, 
    to::            Union{Date, String};
    adjusted::      Union{Bool} = true,
    sort::          Union{AggregatesSort, Symbol, String} = "asc",
    limit::         Int64 = 5000
    )::Union{AggregatesResponse, DataFrame}
    
    raw_aggregates = get_raw_aggregates(
        creds,
        ticker,
        multiplier,
        timespan,
        from,
        to;
        adjusted,
        sort,
        limit
    )
    if creds.content_type === "text/csv"
        return DataFrame(raw_aggregates, ticker)
    elseif creds.content_type == "application/json"
        return AggregatesResponse(raw_aggregates)
    end
end