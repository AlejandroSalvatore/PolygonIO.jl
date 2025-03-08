export TickerDetails
export details

struct TickerDetails
    active::Union{Bool, Nothing}
    cik::Union{String, Nothing}
    composite_figi::Union{String, Nothing}
    currency_name::Union{String, Nothing}
    last_updated_utc::Union{DateTime, Nothing}
    locale::Union{String, Nothing}
    market::Union{String, Nothing}
    name::Union{String, Nothing}
    primary_exchange::Union{String, Nothing}
    share_class_figi::Union{String, Nothing}
    ticker::Union{String, Nothing}
    type::Union{String, Nothing} 
    delisted_utc::Union{DateTime, Nothing}
    description::Union{String, Nothing}
    homepage_url::Union{String, Nothing}
    list_date::Union{DateTime, Nothing}
    market_cap::Union{Float64, Nothing}
    phone_number::Union{String, Nothing}
    share_class_shares_outstanding::Union{Int, Nothing}
    sic_code::Union{String, Nothing}
    sic_description::Union{String, Nothing}
    ticker_root::Union{Nothing, String}
    total_employees::Union{Int, Nothing}
    weighted_shares_outstanding::Union{Int, Nothing}
end


function _TickerDetails(d::Dict{String, Any})
    active = "active" in keys(d) ? d["active"] : nothing
    cik = "cik" in keys(d) ? d["cik"] : nothing
    composite_figi = "composite_figi" in keys(d) ? d["composite_figi"] : nothing
    currency_name = "currency_name" in keys(d) ? d["currency_name"] : nothing
    last_updated_utc = "last_updated_utc" in keys(d) ? DateTime(TimeDateZone(d["last_updated_utc"]).timestamp) : nothing
    locale = "locale" in keys(d) ? d["locale"] : nothing
    market = d["market"]
    name = "name" in keys(d) ? d["name"] : nothing
    primary_exchange = "primary_exchange" in keys(d) ? d["primary_exchange"] : nothing 
    share_class_figi = "share_class_figi" in keys(d) ? d["share_class_figi"] : nothing 
    ticker = d["ticker"]
    type = "type" in keys(d) ? d["type"] : nothing 
    delisted_utc = "delisted_utc" in keys(d) ? DateTime(d["delisted_utc"]) : nothing
    description = "description" in keys(d) ? d["description"] : nothing
    homepage_url = "homepage_url" in keys(d) ? d["homepage_url"] : nothing
    list_date = "list_date" in keys(d) ? DateTime(d["list_date"]) : nothing
    market_cap = "market_cap" in keys(d) ? d["market_cap"] : nothing
    phone_number = "phone_number" in keys(d) ? d["phone_number"] : nothing
    share_class_shares_outstanding = "share_class_shares_outstanding" in keys(d) ? d["share_class_shares_outstanding"] : nothing
    sic_code = "sic_code" in keys(d) ? d["sic_code"] : nothing
    sic_description = "sic_description" in keys(d) ? d["sic_description"] : nothing
    ticker_root = "ticker_root" in keys(d) ? d["ticker_root"] : nothing
    total_employees = "total_employees" in keys(d) ? d["total_employees"] : nothing
    weighted_shares_outstanding = "weighted_shares_outstanding" in keys(d) ? d["weighted_shares_outstanding"] : nothing

    return TickerDetails(active, cik, composite_figi, currency_name, last_updated_utc, locale,
                market, name, primary_exchange, share_class_figi, ticker, type, delisted_utc, 
                description, homepage_url, list_date, market_cap, phone_number, share_class_shares_outstanding,
                sic_code, sic_description, ticker_root, total_employees, weighted_shares_outstanding)
end


function TickerDetails(d::Dict{Symbol, Any})
    active = d[:active]
    cik = d[:cik]
    composite_figi = d[:composite_figi]
    currency_name = d[:currency_name]
    last_updated_utc = d[:last_updated_utc]
    locale = d[:locale]
    market = d[:market]
    name = d[:name]
    primary_exchange = d[:primary_exchange]
    share_class_figi = d[:share_class_figi]
    ticker = d[:ticker]
    type = d[:type]
    delisted_utc = d[:delisted_utc]
    description = d[:description]
    homepage_url = d[:homepage_url]
    list_date = d[:list_date]
    market_cap = d[:market_cap]
    phone_number = d[:phone_number]
    share_class_shares_outstanding = d[:share_class_shares_outstanding]
    sic_code = d[:sic_code]
    sic_description = d[:sic_description]
    ticker_root = d[:ticker_root]
    total_employees = d[:total_employees]
    weighted_shares_outstanding = d[:weighted_shares_outstanding]

    return TickerDetails(active, cik, composite_figi, currency_name, last_updated_utc, locale,
    market, name, primary_exchange, share_class_figi, ticker, type, delisted_utc, 
    description, homepage_url, list_date, market_cap, phone_number, share_class_shares_outstanding,
    sic_code, sic_description, ticker_root, total_employees, weighted_shares_outstanding)
end


function details(c::Credentials, ticker::String; date::Union{String, Nothing} = nothing)
    query = Dict()
    if date !== nothing query["date"] = date end 
    r = HTTP.get(join([endpoint(c), "v3","reference", "tickers", HTTP.URIs.escapeuri(string(ticker))], '/'), query = query, headers = header(c))
    return _TickerDetails(JSON.parse(String(r.body))["results"])
end


function details(c::Credentials; ticker::Union{String, Nothing}=nothing, type::Union{String, Nothing}=nothing, 
    market::Union{String, Nothing}=nothing, exchange::Union{String, Nothing}=nothing, cusip::Union{String, Nothing}=nothing, 
    cik::Union{String, Nothing}=nothing, date::Union{String, Nothing}=nothing, search::Union{String, Nothing}=nothing, 
    active::Union{String, Nothing}=nothing, order::Union{String, Nothing}=nothing, limit::Union{Int, Nothing}=1000, 
    sort::Union{String, Nothing}=nothing)

    query = Dict()
    if ticker !== nothing query["ticker"] = ticker end 
    if type !== nothing query["type"] = type end
    if market !== nothing query["market"] = market end
    if exchange !== nothing query["exchange"] = exchange end 
    if cusip !== nothing query["cusip"] = cusip end 
    if cik !== nothing query["cik"] = cik end 
    if date !== nothing query["date"] = date end 
    if search !== nothing query["search"] = search end 
    if active !== nothing query["active"] = active end 
    if order !== nothing query["order"] = order end 
    if limit !== nothing query["limit"] = limit end 
    if sort !== nothing query["sort"] = sort end 
    query["limit"] = limit 

    r = HTTP.get(join([endpoint(c), "v3", "reference", "tickers"], '/'), query=query, headers = header(c))
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url, headers = header(c))
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return _TickerDetails.(results)
end
