export LastQuoute
export MostRecentMinute
export Snapshot
export snaps
export gainers_snap
export losers_snap
export snap 

struct LastQuote
    ask_price::Float64
    bid_price::Float64
    bid_size::Int
    ask_size::Int
    timestamp::DateTime

end

function _LastQuote(d::Dict{String, Any})
    ask_price = d["P"] 
    bid_price = d["p"] 
    bid_size = d["s"]
    ask_size = d["S"]
    timestamp = unix2datetime(d["t"]//1000)
    return LastQuote(ask_price, bid_price, bid_size, ask_size, timestamp)
end

function LastQuote(d::Dict{Symbol, Any})
    ask_price = d[:ask_price]
    bid_price = d[:bid_price]
    bid_size = d[:bid_size]
    ask_size = d[:ask_size]
    timestamp = d[:timestamp]
    return LastQuote(ask_price, bid_price, bid_size, ask_size, timestamp)
end

struct MostRecentMinute
    accumulated_volume::Int
    timestamp::DateTime
    close::Float64
    high::Float64
    open::Float64
    low::Float64
    volume::Int
    weighted_volume::Float64
    otc::Bool
end

function _MostRecentMinute(d::Dict{String, Any})
    accumulated_volume = d["av"]
    timestamp = unix2datetime(d["t"]//1000)
    close = d["c"]
    high = d["h"]
    open = d["o"]
    low = d["l"]
    volume = d["v"]
    weighted_volume = d["vw"]
    otc = "otc" in keys(d) ? true : false
    return MostRecentMinute(accumulated_volume, timestamp, close, high, open, low, volume, weighted_volume, otc)
end

function MostRecentMinute(d::Dict{Symbol, Any})
    accumulated_volume = d[:accumulated_volume]
    timestamp = d[:timestamp]
    close = d[:close]
    high = d[:high]
    open = d[:open]
    low = d[:low]
    volume = d[:volume]
    weighted_volume = d[:weighted_volume]
    otc = d[:otc]
    return MostRecentMinute(accumulated_volume, timestamp, close, high, open, low, volume, weighted_volume, otc)
end

struct Snapshot
    ticker::String
    change_perc::Float64
    change::Float64
    updated::DateTime
    day::Bar
    prev_day::Bar
    min::MostRecentMinute
    last_trade::Union{Trade, Nothing}
    last_quoute::Union{LastQuote, Nothing}
end    

#= Snapshot -> API =#
function _Snapshot(d::Dict{String, Any})
    ticker = d["ticker"]
    change_perc = d["todaysChangePerc"]
    change = d["todaysChange"]
    updated = unix2datetime(d["updated"]//1000)
    day = _Bar(d["day"])
    prev_day = _Bar(d["prevDay"])
    min = _MostRecentMinute(d["min"])
    last_trade = "lastTrade" in keys(d) ? _LastTrade(d["lastTrade"]) : nothing
    last_quote = "lastQuote" in keys(d) ? _LastQuoute(d["lastQuoute"]) : nothing

    return Snapshot(ticker, change_perc, change, updated, day, prev_day, min, last_trade, last_quote)
end

function Snapshot(d::Dict{Symbol, Any})
    ticker = d[:ticker]
    change_perc = d[:change_perc]
    change = d[:change]
    updated = d[:updated]
    day = d[:day]
    prev_day = d[:prev_day]
    min = d[:min]
    last_trade = d[:last_trade]
    last_quote = d[:last_quote]
    return Snapshot(ticker, change_perc, change, updated, day, prev_day, min, last_trade, last_quote)
end

#= Julia -> API -> Julia =#
function snaps(c::Credentials; tickers::Union{Array{String}, String, Nothing}=nothing, include_otc::Bool=false)

    query = Dict()
    if tickers !== nothing
        query["tickers"] = typeof(tickers) == String ? tickers : join(tickers, ",")
    end
    query["include_otc"] = include_otc

    r = HTTP.get(join([ENDPOINT(c), "v2", "snapshot", "locale", "us", "markets", "stocks", "tickers"], '/'), headers = HEADER(c), query = query)
    return _Snapshot.(JSON.parse(String(r.body))["tickers"])
end

function gainers_snap(c::Credentials, direction::String="gainers"; include_otc::Bool=false)

    query = Dict()
    query["include_otc"] = include_otc

    r = HTTP.get(join([ENDPOINT(c), "v2", "snapshot", "locale", "us", "markets", "stocks", direction], '/'), headers = HEADER(c), query = query)
    return _Snapshot.(JSON.parse(String(r.body))["tickers"])
end


function losers_snap(c::Credentials, direction::String="losers"; include_otc::Bool=false)

    query = Dict()
    query["include_otc"] = include_otc

    r = HTTP.get(join([ENDPOINT(c), "v2", "snapshot", "locale", "us", "markets", "stocks", direction], '/'), headers = HEADER(c), query = query)
    return _Snapshot.(JSON.parse(String(r.body))["tickers"])
end

function snap(c::Credentials, ticker::String)

    r = HTTP.get(join([ENDPOINT(c), "v2", "snapshot", "locale", "us", "markets", "stocks", "tickers", ticker], '/'), headers = HEADER(c))
    return _Snapshot(JSON.parse(String(r.body))["ticker"])
end
