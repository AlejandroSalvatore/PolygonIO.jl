struct Trade
    ticker::Union{String, Nothing}
    conditions::Union{Array{Int64}, Nothing}
    correction::Union{Int64, Nothing}
    trf_timestamp::Union{DateTime, Nothing}
    id::String
    price::Float64
    sequence_number::Union{Int64, Nothing}
    trf_id::Union{Int64, Nothing}
    size::Union{Float64, Nothing}
    sip_timestamp::DateTime
    exchange::Int64
    participant_timestamp::Union{DateTime, Nothing}
    tape::Union{Int64, Nothing}
end

function Trade(d::Dict)
    exchange = d["exchange"]
    id = d["id"]
    price = d["price"]
    sequence_number = d["sequence_number"]
    size = d["size"]
    conditions = "conditions" in keys(d) ? d["conditions"] : nothing
    correction = "correction" in keys(d) ? d["correction"] : nothing
    sip_timestamp = unix2datetime(d["sip_timestamp"]/1e9)
    participant_timestamp = unix2datetime(d["participant_timestamp"]/1e9)
    tape = "tape" in keys(d) ? d["tape"] : nothing
    trf_id = "trf_id" in keys(d) ? d["trf_id"] : nothing
    trf_timestamp = "trf_timestamp" in keys(d) ? unix2datetime(d["trf_timestamp"]/1e9) : nothing
    ticker = "T" in keys(d) ? d["T"] : nothing
    return Trade(ticker, conditions, correction, trf_timestamp, id, price, sequence_number, trf_id, size, sip_timestamp, exchange, participant_timestamp, tape)
end


function get_trades(c::Credentials, ticker::String; timestamp::String=get_date(), filter::String="=", order::String="desc", limit::Int64=50000, sort=nothing)

    query = Dict()
    query["ticker"] = ticker
    query[filter_timestamp(filter)] = timestamp
    if order !== nothing query["order"] = order end 
    if limit !== nothing query["limit"] = limit end 
    if sort !== nothing query["sort"] = sort end 
    query["apiKey"] = c.KEY_ID

    r = HTTP.get(join([ENDPOINT(c), "v3", "trades", "$(ticker)"], '/'), query=query)
    response = JSON.parse(String(r.body))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        r = HTTP.get(next_url*"&apiKey=$(query["apiKey"])")
        response = JSON.parse(String(r.body))
        results_next = response["results"]
        append!(results, results_next)
    end
    return Trade.(results)
end

function LastTrade(d::Dict)
    ticker = "T" in keys(d) ? d["T"] : nothing
    conditions = "c" in keys(d) ? d["c"] : nothing
    correction = "e" in keys(d) ? d["e"] : nothing
    trf_timestamp = "f" in keys(d) ? unix2datetime(d["f"]/1e9) : nothing
    id = d["i"]
    price = d["p"]
    sequence_number = "q" in keys(d) ? d["q"] : nothing
    trf_id = "r" in keys(d) ? d["r"] : nothing
    size = "s" in keys(d) ? d["s"] : nothing
    sip_timestamp = unix2datetime(d["t"]/1e9)
    exchange = d["x"]
    participant_timestamp = "y" in keys(d) ? unix2datetime(d["y"]/1e9) : nothing
    tape = "z" in keys(d) ? d["z"] : nothing 
    return Trade(ticker, conditions, correction, trf_timestamp, id, price, sequence_number, trf_id, size, sip_timestamp, exchange, participant_timestamp, tape)
end


function get_last_trade(c::Credentials, ticker::String)
    query = Dict()
    query["ticker"] = ticker
    query["apiKey"] = c.KEY_ID

    r = HTTP.get(join([ENDPOINT(c), "v2", "last", "trade", "$(ticker)"], '/'), query=query)
    response = JSON.parse(String(r.body))
    results = response["results"]

    return LastTrade(results)
end