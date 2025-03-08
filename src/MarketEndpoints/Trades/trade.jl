export Trade
export trades
export last_trade 

abstract type AbstractTrade end

struct Trade <: AbstractTrade
    ticker::Union{String, Nothing}
    conditions::Union{Array{Int64}, Nothing}
    correction::Union{Int64, Nothing}
    exchange::Int64
    id::String
    participant_timestamp::Union{Int64, Nothing}
    price::Float64
    sequence_number::Union{Int64, Nothing}
    sip_timestamp::Union{Int64, Nothing}
    size::Union{Float64, Nothing}
    tape::Union{Int64, Nothing}
    trf_id::Union{Int64, Nothing}
    trf_timestamp::Union{Int64, Nothing}
end

function Trade(d::Dict{String, Any})
    exchange = d["exchange"]
    id = d["id"]
    price = d["price"]
    sequence_number = d["sequence_number"]
    size = d["size"]
    conditions = get(d, "conditions",  nothing)
    correction = get(d, "correction", nothing)
    sip_timestamp = get(d, "sip_timestamp", nothing)
    participant_timestamp = get(d, "participant_timestamp", nothing)
    tape = get(d, "tape", nothing)
    trf_id = get(d, "trf_id", nothing)
    trf_timestamp = get(d, "trf_timestamp", nothing)
    ticker = get(d, "T", nothing)
    return Trade(
        ticker,
        conditions,
        correction,
        exchange,
        id,
        participant_timestamp,
        price,
        sequence_number,
        sip_timestamp,
        size,
        tape,
        trf_id,
        trf_timestamp,
    )
end
