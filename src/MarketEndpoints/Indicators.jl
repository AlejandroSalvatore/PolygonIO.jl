export sma
export ema
export rsi
export macd
export IndicatorValue
export Indicator


struct IndicatorValue
    value::Float64
    timestamp::DateTime
    histogram::Union{Float64, Nothing}
    signal::Union{Float64, Nothing}
end


function _IndicatorValue(d::Dict{String, Any})
    histogram = "histogram" in keys(d) ? d["histogram"] : nothing
    signal = "signal" in keys(d) ? d["signal"] : nothing
    timestamp = unix2datetime(d["timestamp"]//1000)
    value = d["value"]
    return IndicatorValue(value, timestamp, histogram, signal)
end


function IndicatorValue(d::Dict{Symbol, Any})
    histogram = d[:histogram]
    signal = d[:signal]
    timestamp = d[:timestamp]
    value = d[:value]
    return IndicatorValue(value, timestamp, histogram, signal)
end


struct Indicator
    bars::Union{Vector{Bar}, Nothing}
    values::Vector{IndicatorValue}
    url_aggs::Union{String, Nothing}
end


function _Indicator(d::Dict{String, Any})
    underlying = "underlying" in keys(d) ? d["underlying"] : nothing
    if underlying !== nothing
        aggs = "aggregates" in keys(underlying) ? underlying["aggregates"] : nothing
        bars = aggs !== nothing ? _Bar.(aggs) : nothing
        url_aggs = underlying["url"]
    end     
    values = _IndicatorValue.(d["values"])
    return Indicator(bars, values, url_aggs)
end


function Indicator(d::Dict{Symbol, Any})
    bars = d[:bars]
    url_aggs = d[:url_aggs]
    values = d[:values]
    return Indicator(bars, values, url_aggs)
end


function sma(
    c::Credentials,
    ticker::String, 
    timespan::Type{T} where {T<:BarTimeSpan}; 
    filter::String="=", 
    timestamp::String=get_date(), 
    adjusted::Bool=true, window::Int64=5, 
    series_type::String="close", 
    expand_underlying::Bool=false, 
    order::String="desc", 
    limit::Int64=5000
    )
    
    query = Dict()
    query["stockTicker"] = ticker
    query[filter_timestamp(filter)] = timestamp
    query["timespan"] = BarTimeSpan(timespan)
    query["adjusted"] = string(adjusted)
    query["window"] = window
    query["series_type"] = series_type
    query["expand_underlying"] = string(expand_underlying)
    query["order"] = order
    query["limit"] = limit


    r = HTTP.get(join([ENDPOINT(c), "v1", "indicators", "sma", "$(ticker)"], '/'), headers = HEADER(c), query = query)
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url, headers = HEADER(c))
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return _Indicator(results)
end

function ema(
    c::Credentials,
    ticker::String, 
    timespan::Type{T} where {T<:BarTimeSpan}; 
    filter::String="=", 
    timestamp::String=get_date(), 
    adjusted::Bool=true, window::Int64=5, 
    series_type::String="close", 
    expand_underlying::Bool=false, 
    order::String="desc", 
    limit::Int64=5000
    )
    
    query = Dict()
    query["stockTicker"] = ticker
    query[filter_timestamp(filter)] = timestamp
    query["timespan"] = BarTimeSpan(timespan)
    query["adjusted"] = string(adjusted)
    query["window"] = window
    query["series_type"] = series_type
    query["expand_underlying"] = string(expand_underlying)
    query["order"] = order
    query["limit"] = limit


    r = HTTP.get(join([ENDPOINT(c), "v1", "indicators", "ema", "$(ticker)"], '/'), headers = HEADER(c), query = query)
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url, headers = HEADER(c))
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return _Indicator(results)
end

function rsi(
    c::Credentials,
    ticker::String, 
    timespan::Type{T} where {T<:BarTimeSpan}; 
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
    query["stockTicker"] = ticker
    query[filter_timestamp(filter)] = timestamp
    query["timespan"] = BarTimeSpan(timespan)
    query["adjusted"] = string(adjusted)
    query["window"] = window
    query["series_type"] = series_type
    query["expand_underlying"] = string(expand_underlying)
    query["order"] = order
    query["limit"] = limit


    r = HTTP.get(join([ENDPOINT(c), "v1", "indicators", "rsi", "$(ticker)"], '/'), headers = HEADER(c), query = query)
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url, headers = HEADER(c))
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return _Indicator(results)
end

function macd(
    c::Credentials,
    ticker::String, 
    timespan::Type{T} where T <: BarTimeSpan, 
    short_window::Int64, 
    long_window::Int64, 
    signal_window::Int64; 
    filter::String="=", 
    timestamp::String=get_date(), 
    adjusted::Bool=true, 
    series_type::String="close", 
    expand_underlying::Bool=false, 
    order::String="desc", 
    limit::Int64=5000
    )
    
    query = Dict()
    query["stockTicker"] = ticker
    query[filter_timestamp(filter)] = timestamp
    query["timespan"] = BarTimeSpan(timespan)
    query["adjusted"] = string(adjusted)
    query["short_window"] = short_window
    query["long_window"] = long_window
    query["signal_window"] = signal_window
    query["series_type"] = series_type
    query["expand_underlying"] = string(expand_underlying)
    query["order"] = order
    query["limit"] = limit

    r = HTTP.get(join([ENDPOINT(c), "v1", "indicators", "macd", "$(ticker)"], '/'), headers = HEADER(c), query = query)
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url, headers = HEADER(c))
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return _Indicator(results)
end
