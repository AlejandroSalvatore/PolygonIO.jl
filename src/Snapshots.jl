#= Abstract -> Snapshot =#
struct Day
    open::Float64
    high::Float64
    low::Float64
    close::Float64
    volume::Float64
    weighted_volume::Float64
    otc::Bool
end

function Day(d::Dict)
    open = d["o"] 
    high = d["h"] 
    low = d["l"]
    close = d["c"] 
    weighted_volume = d["vw"]
    volume = d["v"]
    otc = "otc" in keys(d) ? false : true
    return Day(open, high, low, close, volume, weighted_volume, otc)
end

struct LastQuote
    ask_price::Float64
    bid_price::Float64
    bid_size::Int
    ask_size::Int
    timestamp::DateTime

end

function LastQuote(d::Dict)
    ask_price = d["P"] 
    bid_price = d["p"] 
    bid_size = d["s"]
    ask_size = d["S"]
    timestamp = unix2datetime(d["t"]//1000)
    return LastQuote(ask_price, bid_price, bid_size, ask_size, timestamp)
end

struct LastTrade
    conditions::Union{Array{Int}, Nothing}
    id::String
    price::Float64
    size::Int
    timestamp::DateTime
    exchange_id::Int
end

function LastTrade(d::Dict)
    conditions = d["c"]
    id = d["i"]
    price = d["p"]
    size = d["s"]
    timestamp = unix2datetime(d["t"]//1000)
    exchange_id = d["x"]
    return LastTrade(conditions, id, price, size, timestamp, exchange_id)
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

function MostRecentMinute(d::Dict)
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

struct Snapshot
    ticker::String
    change_perc::Float64
    change::Float64
    updated::DateTime
    day::Day
    prev_day::Day
    min::MostRecentMinute
    last_trade::Union{LastTrade, Nothing}
    last_quoute::Union{LastQuote, Nothing}
end    

#= Snapshot -> API =#
function Snapshot(d::Dict)
    ticker = d["ticker"]
    change_perc = d["todaysChangePerc"]
    change = d["todaysChange"]
    updated = unix2datetime(d["updated"])
    day = Day(d["day"])
    prev_day = Day(d["prevDay"])
    min = MostRecentMinute(d["min"])
    last_trade = "lastTrade" in keys(d) ? LastTrade(d["lastTrade"]) : nothing
    last_quote = "lastQuote" in keys(d) ? LastQuoute(d["lastQuoute"]) : nothing

    return Snapshot(ticker, change_perc, change, updated, day, prev_day, min, last_trade, last_quote)
end

#= Julia -> API -> Julia =#
function get_snaps(c::Credentials; tickers::Union{Array{String}, String, Nothing}=nothing, include_otc::Bool=false)

    query = Dict()
    if tickers !== nothing
        query["tickers"] = typeof(tickers) == String ? tickers : join(tickers, ",")
    end
    query["include_otc"] = include_otc
    query["apiKey"] = c.KEY_ID

    r = HTTP.get(join([ENDPOINT(c), "v2", "snapshot", "locale", "us", "markets", "stocks", "tickers"], '/'), header = HEADER(c), query = query)
    return Snapshot.(JSON.parse(String(r.body))["tickers"])
end

function get_gainers_snap(c::Credentials, direction::String="gainers"; include_otc::Bool=false)

    query = Dict()
    query["include_otc"] = include_otc
    query["apiKey"] = c.KEY_ID

    r = HTTP.get(join([ENDPOINT(c), "v2", "snapshot", "locale", "us", "markets", "stocks", direction], '/'), header = HEADER(c), query = query)
    return Snapshot.(JSON.parse(String(r.body))["tickers"])
end


function get_losers_snap(c::Credentials, direction::String="losers"; include_otc::Bool=false)

    query = Dict()
    query["include_otc"] = include_otc
    query["apiKey"] = c.KEY_ID

    r = HTTP.get(join([ENDPOINT(c), "v2", "snapshot", "locale", "us", "markets", "stocks", direction], '/'), header = HEADER(c), query = query)
    return Snapshot.(JSON.parse(String(r.body))["tickers"])
end

function get_snap(c::Credentials, ticker::String)

    query = Dict()
    query["apiKey"] = c.KEY_ID

    r = HTTP.get(join([ENDPOINT(c), "v2", "snapshot", "locale", "us", "markets", "stocks", "tickers", ticker], '/'), header = HEADER(c), query = query)
    return Snapshot(JSON.parse(String(r.body))["ticker"])
end