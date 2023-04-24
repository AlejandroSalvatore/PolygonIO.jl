#= Abstract -> Indicator =#

struct IndicatorValue
    value::Float64
    timestamp::DateTime
    histogram::Union{Float64, Nothing}
    signal::Union{Float64, Nothing}
end

function IndicatorValue(d::Dict)
    histogram = "histogram" in keys(d) ? d["histogram"] : nothing
    signal = "signal" in keys(d) ? d["signal"] : nothing
    timestamp = unix2datetime(d["timestamp"]//1000)
    value = d["value"]
    return IndicatorValue(value, timestamp, histogram, signal)
end

struct Indicator
    bars::Union{Vector{Bar}, Nothing}
    values::Vector{IndicatorValue}
    url_aggs::Union{String, Nothing}
end

function Indicator(d::Dict)
    underlying = "underlying" in keys(d) ? d["underlying"] : nothing
    if underlying !== nothing
        aggs = "aggregates" in keys(underlying) ? underlying["aggregates"] : nothing
        bars = aggs !== nothing ? Bar.(aggs) : nothing
        url_aggs = underlying["url"]
    end     
    values = IndicatorValue.(d["values"])
    return Indicator(bars, values, url_aggs)
end

function get_sma(
    c::Credentials,
    ticker::String, 
    timespan::Type{T} where {T<:AggTimeSpan}; 
    filter::String="=", 
    timestamp::String=get_date(), 
    adjusted::Bool=true, window::Int64=5, 
    series_type::String="close", 
    expand_underlying::Bool=false, 
    order::String="desc", 
    limit::Int64=5000
    )
    
    query = Dict()
    query["apiKey"] = c.KEY_ID
    query["stockTicker"] = ticker
    query[filter_timestamp(filter)] = timestamp
    query["timespan"] = AggTimeSpan(timespan)
    query["adjusted"] = string(adjusted)
    query["window"] = window
    query["series_type"] = series_type
    query["expand_underlying"] = string(expand_underlying)
    query["order"] = order
    query["limit"] = limit


    r = HTTP.get(join([ENDPOINT(c), "v1", "indicators", "sma", "$(ticker)"], '/'), header = HEADER(c), query = query)
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url*"&apiKey=$(query["apiKey"])")
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return Indicator(results)
end

function get_ema(
    c::Credentials,
    ticker::String, 
    timespan::Type{T} where {T<:AggTimeSpan}; 
    filter::String="=", 
    timestamp::String=get_date(), 
    adjusted::Bool=true, window::Int64=5, 
    series_type::String="close", 
    expand_underlying::Bool=false, 
    order::String="desc", 
    limit::Int64=5000
    )
    
    query = Dict()
    query["apiKey"] = c.KEY_ID
    query["stockTicker"] = ticker
    query[filter_timestamp(filter)] = timestamp
    query["timespan"] = AggTimeSpan(timespan)
    query["adjusted"] = string(adjusted)
    query["window"] = window
    query["series_type"] = series_type
    query["expand_underlying"] = string(expand_underlying)
    query["order"] = order
    query["limit"] = limit


    r = HTTP.get(join([ENDPOINT(c), "v1", "indicators", "ema", "$(ticker)"], '/'), header = HEADER(c), query = query)
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url*"&apiKey=$(query["apiKey"])")
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return Indicator(results)
end

function get_rsi(
    c::Credentials,
    ticker::String, 
    timespan::Type{T} where {T<:AggTimeSpan}; 
    filter::String="=", 
    timestamp::String=get_date(), 
    adjusted::Bool=true, 
    window::Int64=5, 
    series_type::String="close", 
    expand_underlying::Bool=false, 
    order::String="desc", 
    limit::Int64=5000
    )
    
    query = Dict()
    query["apiKey"] = c.KEY_ID
    query["stockTicker"] = ticker
    query[filter_timestamp(filter)] = timestamp
    query["timespan"] = AggTimeSpan(timespan)
    query["adjusted"] = string(adjusted)
    query["window"] = window
    query["series_type"] = series_type
    query["expand_underlying"] = string(expand_underlying)
    query["order"] = order
    query["limit"] = limit


    r = HTTP.get(join([ENDPOINT(c), "v1", "indicators", "rsi", "$(ticker)"], '/'), header = HEADER(c), query = query)
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url*"&apiKey=$(query["apiKey"])")
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return Indicator(results)
end

function get_macd(
    c::Credentials,
    ticker::String, 
    timespan::AggTimeSpan, 
    short_window, 
    long_window, 
    signal_window; 
    filter::String="=", 
    timestamp::String=get_date(), 
    adjusted::Bool=true, 
    series_type::String="close", 
    expand_underlying::Bool=false, 
    order::String="desc", 
    limit::Int64=5000
    )
    
    query = Dict()
    query["apiKey"] = c.KEY_ID
    query["stockTicker"] = ticker
    query[filter_timestamp(filter)] = timestamp
    query["timespan"] = AggTimeSpan(timespan)
    query["adjusted"] = string(adjusted)
    query["short_window"] = short_window
    query["long_window"] = long_window
    query["signal_window"] = signal_window
    query["series_type"] = series_type
    query["expand_underlying"] = string(expand_underlying)
    query["order"] = order
    query["limit"] = limit

    r = HTTP.get(join([ENDPOINT(c), "v1", "indicators", "macd", "$(ticker)"], '/'), header = HEADER(c), query = query)
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url*"&apiKey=$(query["apiKey"])")
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return Indicator(results)
end