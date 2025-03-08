struct TickerLastQuote <: AbstractBar
    ask_price::Union{Float64, Nothing}
    ask_size::Union{Float64, Nothing}
    bid_price::Union{Float64, Nothing}
    bid_size::Union{Float64, Nothing}
    sip_timestamp::Union{Int64, Nothing}
end

function TickerLastQuote(d::Dict{String, Any})

    ask_price = get(d, "P", nothing)
    ask_size = get(d, "S", nothing)
    bid_price = get(d, "p", nothing)
    bid_size = get(d, "s", nothing)
    sip_timestamp = get(d, "t", nothing)

    return TickerLastQuote(
        ask_price,
        ask_size,
        bid_price,
        bid_size,
        sip_timestamp
    )

end
