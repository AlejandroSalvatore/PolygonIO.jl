struct GroupedDailyResponse
    adjusted::Bool
    query_count::Int64
    request_id::String
    results::Vector{GroupedDailyBar}
    results_count::Union{Int64, Nothing}
    status::String
end

function GroupedDailyResponse(d::Dict{String, Any})
    adjusted = d["adjusted"]
    query_count = d["queryCount"]
    request_id = d["request_id"]
    results = GroupedDailyBar.(d["results"])
    results_count = get(d, "results_count", nothing)
    status = d["status"]
    return GroupedDailyResponse(
        adjusted,
        query_count,
        request_id,
        results,
        results_count,
        status,
    )
end

function grouped_daily_query(
    adjusted::Union{Bool, Nothing},
    include_otc::Union{Bool, Nothing}
    )::Dict{String, String}
    query = Dict(
        "adjusted" => adjusted === nothing ? nothing : string(adjusted),
        "include_otc" => include_otc === nothing ? nothing : string(include_otc)
    )
    return query
end

function get_raw_grouped_daily(
    c::             Credentials,
    date::          Union{Date, String};
    adjusted::      Union{Bool, Nothing} = true,
    include_otc::   Union{Bool, Nothing} = false,
    )::HTTP.Response

    # TODO: Check for unavailable dates
    # if ! is_date_available(date)
    #     @warn "The market is not open yet on date $date"
    query = grouped_daily_query(adjusted, include_otc)
        
    r = HTTP.get(join([endpoint(c), "v2","aggs", "grouped", "locale", "us", "market", "stocks", 
    HTTP.URIs.escapeuri(string(date))], '/'), query = query, headers = header(c))
    return r
end

function GroupedDailyResponse(raw_response::HTTP.Response)
    json_response = JSON.parse(String(raw_response.body))
    return GroupedDailyResponse(json_response)
end
    
function DataFrames.DataFrame(grouped_daily::GroupedDailyResponse, except_fields::Vector{String}=["results"])
    df = DataFrame(aggregates.results)
    for field in fieldnames(GroupedDailyResponse)
        if !(String(field) in except_fields)
            metadata!(df, String(field), getproperty(grouped_daily, field))
        end
    end
    return df
end

function grouped_daily(
    creds::         Credentials,
    date::          Union{Date, String};
    adjusted::      Union{Bool, Nothing} = true,
    include_otc::   Union{Bool, Nothing} = false,
    )::Union{GroupedDailyResponse, DataFrame}

    raw_grouped_daily = get_raw_grouped_daily(
        creds,
        date;
        adjusted,
        include_otc
    )
    if creds.content_type == "application/json"
        return GroupedDailyResponse(raw_grouped_daily)
    elseif creds.content_type == "text/csv"
        return DataFrame(raw_grouped_daily)
    end
end