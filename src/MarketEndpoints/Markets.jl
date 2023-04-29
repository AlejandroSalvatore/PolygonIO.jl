#= Abstract -> MarketHoliday =#
export MarketHoliday
export market_holidays
export MarketStatus
export market_status

struct MarketHoliday
    date::Date
    exchange::String
    name::String
    open::Union{TimeDateZone, Nothing}
    close::Union{TimeDateZone, Nothing}
    status::String 
end    

#Fix for optional close and open
#= MarketHoliday -> API =#
function _MarketHoliday(d::Dict{String, Any})
    date = Date(d["date"])
    exchange = d["exchange"]
    name =d["name"]
    open = "open" in keys(d) ? TimeDateZone(d["open"]) : nothing
    close = "close" in keys(d) ? TimeDateZone(d["close"]) : nothing
    status = d["status"]
    return MarketHoliday(date, exchange, name, open, close, status)
end

function MarketHoliday(d::Dict{Symbol, Any})
    date = d[:date]
    exchange = d[:exchange]
    name =d[:name]
    open = d[:open]
    close = d[:close]
    status = d[:status]
    return MarketHoliday(date, exchange, name, open, close, status)
end


#= Julia -> API -> Julia =#
function market_holidays(c::Credentials)
    r = HTTP.get(join([ENDPOINT(c), "v1", "marketstatus", "upcoming"], "/"), headers = HEADER(c))
    return _MarketHoliday.(JSON.parse(String(r.body)))
end

#= Abstract -> MarketStatus =#
struct MarketStatus
    afterHours::Bool
    currencies::Dict
    earlyHours::Bool
    exchanges::Dict
    market::String
    serverTime::TimeDateZone  
end

#= MarketStatus -> API =#
function _MarketStatus(d::Dict{String, Any})
    afterHours = d["afterHours"]
    currencies = d["currencies"]
    earlyHours = d["earlyHours"]
    exchanges = d["exchanges"]
    market = d["market"]
    serverTime = TimeDateZone(d["serverTime"])
    return MarketStatus(afterHours, currencies, earlyHours, exchanges, market, serverTime)
end

#= MarketStatus -> API =#
function MarketStatus(d::Dict{Symbol, Any})
    afterHours = d[:afterHours]
    currencies = d[:currencies]
    earlyHours = d[:earlyHours]
    exchanges = d[:exchanges]
    market = d[:market]
    serverTime = d[:serverTime]
    return MarketStatus(afterHours, currencies, earlyHours, exchanges, market, serverTime)
end

#= Julia -> API -> MarketStatus =#
function market_status(c::Credentials)
    r = HTTP.get(join([ENDPOINT(c), "v1", "marketstatus", "now"], "/"), headers = HEADER(c))
    return _MarketStatus(JSON.parse(String(r.body)))
end
