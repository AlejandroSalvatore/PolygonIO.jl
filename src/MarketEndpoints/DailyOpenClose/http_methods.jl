struct OpenCloseBar<:AbstractBar
    after_hours::Union{Float64, Nothing}
    close::Union{Float64, Nothing}
    from::Date
    high::Float64
    low::Float64
    open::Float64
    otc::Union{Bool, Nothing}
    pre_market::Union{Float64, Nothing}
    status::String
    symbol::String
    volume::Int64
end

struct OpenCloseBarResponse<:AbstractBar
    after_hours::Union{Float64, Nothing}
    close::Union{Float64, Nothing}
    from::Date
    high::Float64
    low::Float64
    open::Float64
    otc::Union{Bool, Nothing}
    pre_market::Union{Float64, Nothing}
    status::String
    symbol::String
    volume::Int64
end

function OpenCloseBarResponse(d::Dict{String, Any})
    after_hours = d["afterHours"]
    close = d["close"]
    from = Date(d["from"])
    high = d["high"]
    low = d["low"]
    open = d["open"]
    otc = "otc" in keys(d) ? d["otc"] : nothing
    pre_market = d["preMarket"]
    status = d["status"]
    symbol = d["symbol"]
    volume = d["volume"]
    return OpenCloseBarResponse(
        after_hours,
        close,
        from,
        high,
        low,
        open,
        otc,
        pre_market,
        status,
        symbol,
        volume
    )
end

function OpenCloseBar(d::Dict{String, Any})
    after_hours = d["afterHours"]
    close = d["close"]
    from = Date(d["from"])
    high = d["high"]
    low = d["low"]
    open = d["open"]
    otc = "otc" in keys(d) ? d["otc"] : nothing
    pre_market = d["preMarket"]
    status = d["status"]
    symbol = d["symbol"]
    volume = d["volume"]
    return OpenCloseBar(
        after_hours,
        close,
        from,
        high,
        low,
        open,
        otc,
        pre_market,
        status,
        symbol,
        volume
    )
end

function daily_bar_query(
    adjusted::Union{Bool, Nothing},
    )::Dict{String, String}
    return  Dict(
        "adjusted" => adjusted === nothing ? nothing : string(adjusted),
    )
end

function get_raw_open_close_bar(
    creds::         Credentials,
    date::          Union{Date, String},
    stocksTicker::  String;
    adjusted::      Union{Bool, Nothing} = true
    )::HTTP.Response
    query = daily_bar_query(adjusted)
    r = HTTP.get(join([endpoint(creds), "v1", "open-close", 
    HTTP.URIs.escapeuri(stocksTicker), HTTP.URIs.escapeuri(string(date))], '/'), 
    query = query, headers = header(creds))
    return r
end

function OpenCloseBarResponse(raw_response::HTTP.Response)
    json_response = JSON.parse(String(raw_response.body))
    return OpenCloseBarResponse(json_response)
end

function DataFrames.DataFrame(open_close::OpenCloseBarResponse, except_fields::Vector{String}=["status"])
    df = DataFrame(open_close.results)
    for field in fieldnames(open_close)
        if !(String(field) in except_fields)
            metadata!(df, String(field), getproperty(aggregates, field))
        end
    end
    return df
end

function open_close_bar(
    creds::         Credentials,
    symbol::        String,
    date::          Union{Date, String};
    adjusted::      Union{Bool, Nothing} = true,
    )::Union{OpenCloseBarResponse, DataFrame}

    # TODO: Add parsing of Date to String

    raw_open_close = get_raw_open_close_bar(
        creds,
        date,
        symbol;
        adjusted
    )
    if creds.content_type == "application/json"
        return OpenCloseBarResponse(raw_open_close)
    elseif creds.content_type == "text/csv"
        return DataFrame(raw_open_close)
    end
end