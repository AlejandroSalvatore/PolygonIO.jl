export Bar
export bars
export daily_bars
export DailyBar
export daily_bar
export previous_bar

abstract type BarTimeSpan end

struct minute <: BarTimeSpan end
struct hour <: BarTimeSpan end 
struct day <: BarTimeSpan end
struct week <: BarTimeSpan end
struct month <: BarTimeSpan end
struct quarter <: BarTimeSpan end
struct year <: BarTimeSpan end 

BarTimeSpan(::Type{minute}, x::String="minute") = x
BarTimeSpan(::Type{hour}, x::String="hour") = x
BarTimeSpan(::Type{day}, x::String="day") = x
BarTimeSpan(::Type{week}, x::String="week") = x
BarTimeSpan(::Type{month}, x::String="month") = x
BarTimeSpan(::Type{quarter}, x::String="quarter") = x
BarTimeSpan(::Type{year}, x::String="year") = x


struct Bar
    ticker::Union{String, Nothing}
    close::Float64
    high::Float64
    low::Float64
    number::Union{Float64, Nothing}
    open::Float64
    timestamp::Union{DateTime, Nothing}
    volume::Number
    weighted_volume::Union{Float64, Nothing}
    otc::Bool
end


function _Bar(d::Dict{String, Any})
    ticker = "T" in keys(d) ? d["T"] : nothing
    close = d["c"]
    high = d["h"]
    low = d["l"]
    number = "n" in keys(d) ? d["n"] : nothing
    open = d["o"]
    timestamp = "t" in keys(d) ? unix2datetime(d["t"]//1000) : nothing
    volume = d["v"]
    weighted_volume = "vw" in keys(d) ? d["vw"] : nothing
    otc = "otc" in keys(d) ? true : false
    return Bar(ticker, close, high, low, number, open, timestamp, volume, weighted_volume, otc)
end


function Bar(d::Dict{Symbol, Any})
    ticker = d[:ticker]
    close = d[:close]
    high = d[:high]
    low = d[:low]
    number = d[:number]
    open = d[:open]
    timestamp = d[:timestamp]
    volume = d[:volume]
    weighted_volume = d[:weighted_volume]
    otc = d[:otc]   
    return Bar(ticker, close, high, low, number, open, timestamp, volume, weighted_volume, otc)
end


# struct Agg
#     adjusted::Bool
#     queryCount::Int
#     request_id::Union{String, Nothing}
#     results::Union{Vector{Bar}, Nothing}
#     resultsCount::Int
#     status::String
#     ticker::Union{String, Nothing}
# end

# function Agg(d::Dict{String, Any})
#     adjusted = d["adjusted"]
#     queryCount = d["queryCount"]
#     request_id = "request_id" in keys(d) ? d["request_id"] : nothing
#     results = "results" in keys(d) ? Bar.(d["results"]) : nothing 
#     resultsCount = d["resultsCount"]
#     status = d["status"]
#     ticker = "ticker" in keys(d) ? d["ticker"] : nothing
#     return Agg(adjusted, queryCount, request_id, results, resultsCount, status, ticker)
# end

function bars(
    c::             Credentials, 
    ticker::        String, 
    multiplier::    Int, 
    timespan::      Type{T} where {T<:BarTimeSpan}, 
    from::          String, 
    to::            String;
    adjusted::      Union{Bool, Nothing} = true,
    sorted::        Union{String, Nothing} = "desc",
    limit::         Union{Int, Nothing} = 5000
    )

    query = Dict()
    query["adjusted"] = adjusted === nothing ? nothing : string(adjusted)
    query["sorted"] = sorted === nothing ? nothing : string(sorted)
    query["limit"] = adjusted === nothing ? nothing : string(limit)

    timespan = BarTimeSpan(timespan)

    r = HTTP.get(join([ENDPOINT(c), "v2","aggs", "ticker", HTTP.URIs.escapeuri(string(ticker)), "range", 
    HTTP.URIs.escapeuri(string(multiplier)), HTTP.URIs.escapeuri(timespan), HTTP.URIs.escapeuri(string(from)),
    HTTP.URIs.escapeuri(string(to))], '/'), headers = HEADER(c), query = query)
    body = JSON.parse(String(r.body))
    if "results" in keys(body)
        bars = body["results"]
        ticker = body["ticker"]
        for bar in bars
            bar["T"] = ticker
        end
        return _Bar.(bars)
    else
        return nothing
    end
end


function daily_bars(
    c::             Credentials,
    date::          String;
    adjusted::      Union{Bool, String} = true,
    include_otc::   Union{Bool, String} = false
    )

    if date_available(date)

        query = Dict()
        query["adjusted"] = adjusted === nothing ? nothing : string(adjusted)
        query["include_otc"] = include_otc === nothing ? nothing : string(include_otc)

        r = HTTP.get(join([ENDPOINT(c), "v2","aggs", "grouped", "locale", "us", "market", "stocks",HTTP.URIs.escapeuri(date)], '/'), 
        query = query, headers = HEADER(c))
        bars = JSON.parse(String(r.body))["results"]
        return _Bar.(bars)

    else
        throw(error("The market is not open for date $(date)"))
    end
end


struct DailyBar
    afterHours::Float64
    close::Float64
    from::DateTime
    high::Float64
    low::Float64
    open::Float64
    preMarket::Float64
    status::String
    ticker::String
    volume::Int
    otc::Bool
end


function _DailyBar(d::Dict{String, Any})
    afterHours = d["afterHours"]
    close = d["close"]
    from = DateTime(d["from"])
    high = d["high"]
    low = d["low"]
    open = d["open"]
    preMarket = d["preMarket"]
    status = d["status"]
    ticker = d["symbol"]
    volume = d["volume"]
    otc = "otc" in keys(d) ? true : false
    return DailyBar(afterHours, close, from, high, low, open, preMarket, status, ticker, volume, otc)
end


function DailyBar(d::Dict{Symbol, Any})
    afterHours = d[:afterHours]
    close = d[:close]
    from = DateTime(d[:from])
    high = d[:high]
    low = d[:low]
    open = d[:open]
    preMarket = d[:premarket]
    status = d[:status]
    ticker = d[:ticker]
    volume = d[:volume]
    otc = d[:otc]
    return DailyBar(afterHours, close, from, high, low, open, preMarket, status, ticker, volume, otc)
end


function daily_bar(
    c::             Credentials,
    date::          String,
    stocksTicker::  String;
    adjusted::   Union{Bool, String} = true
    )

    if date_available(date)

    query = Dict()
    query["adjusted"] = adjusted === nothing ? nothing : string(adjusted)

    r = HTTP.get(join([ENDPOINT(c), "v1", "open-close", HTTP.URIs.escapeuri(stocksTicker), HTTP.URIs.escapeuri(date)], '/'), query = query, headers = HEADER(c))
    bars = JSON.parse(String(r.body))
    return _DailyBar(bars)

    else
        throw(error("The market is not open for date $(date)"))

    end
end


function previous_bar(
    c::             Credentials,
    stocksTicker:: String;
    adjusted::      Union{Bool, String} = true,
    )

    query = Dict()
    query["adjusted"] = adjusted === nothing ? nothing : string(adjusted)

    r = HTTP.get(join([ENDPOINT(c), "v2","aggs", "ticker", HTTP.URIs.escapeuri(stocksTicker) , "prev"], '/'), query = query, headers = HEADER(c))
    bar = JSON.parse(String(r.body))["results"][1]
    return _Bar(bar)
end
