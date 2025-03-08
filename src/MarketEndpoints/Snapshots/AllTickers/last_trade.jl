struct TickerLastTrade <: AbstractTrade
    conditions::Union{Array{Int64}, Nothing}
    id::Union{String, Nothing}
    price::Union{Float64, Nothing}
    size::Union{Int64, Nothing}
    sip_timestamp::Union{Int64, Nothing}
    exchange::Union{Int64, Nothing}
end

function TickerLastTrade(d::Dict{String, Any})

    conditions = get(d, "c", nothing)
    id = get(d, "i", nothing)
    price = get(d, "p", nothing)
    size = get(d, "s", nothing)
    sip_timestamp = get(d, "t", nothing)
    exchange = get(d, "x", nothing)

    return TickerLastTrade(
        conditions,
        id,
        price,
        size,
        sip_timestamp,
        exchange
    )

end
