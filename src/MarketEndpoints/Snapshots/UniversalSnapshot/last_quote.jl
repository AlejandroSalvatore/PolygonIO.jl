struct SnapshotLastQuote
    ask::Union{Float64, Nothing}
    ask_exchange::Union{Int64, Nothing}
    ask_size::Union{Float64, Nothing}
    bid::Union{Float64, Nothing}
    bid_exchange::Union{Int64, Nothing}
    bid_size::Union{Float64, Nothing}
    last_updated::Union{Int64, Nothing}
    midpoint::Union{Float64, Nothing}
    timeframe::Union{String, Nothing}
end

function SnapshotLastQuote(d::Dict{String, Any})

    ask = get(d, "ask", nothing)
    ask_exchange = get(d, "ask_exchange", nothing)
    ask_size = get(d, "ask_size", nothing)
    bid = get(d, "bid", nothing)
    bid_exchange = get(d, "bid_exchange", nothing)
    bid_size = get(d, "bid_size", nothing)
    last_updated = get(d, "last_updated", nothing)
    midpoint = get(d, "midpoint", nothing)
    timeframe = get(d, "timeframe", nothing)

    return SnapshotLastQuote(
        ask,
        ask_exchange,
        ask_size,
        bid,
        bid_exchange,
        bid_size,
        last_updated,
        midpoint,
        timeframe
    )
    
end
