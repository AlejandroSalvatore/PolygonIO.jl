struct LastTrade
    ticker::Union{String, Nothing}
    conditions::Union{Array{Int64}, Nothing}
    correction::Union{Int64, Nothing}
    trf_timestamp::Union{Int64, Nothing}
    id::Union{String, Nothing}
    price::Union{Float64, Nothing}
    sequence_number::Union{Int64, Nothing}
    trf_id::Union{Int64, Nothing}
    size::Union{Float64, Nothing}
    sip_timestamp::Union{Int64, Nothing}
    exchange::Union{Int64, Nothing}
    participant_timestamp::Union{Int64, Nothing}
    tape::Union{Int64, Nothing}
end

function LastTrade(d::Dict{String, Any})
    ticker = "T" in keys(d) ? d["T"] : nothing
    conditions = "c" in keys(d) ? d["c"] : nothing
    correction = "e" in keys(d) ? d["e"] : nothing
    trf_timestamp = "f" in keys(d) ? d["f"] : nothing
    id = d["i"]
    price = d["p"]
    sequence_number = "q" in keys(d) ? d["q"] : nothing
    trf_id = "r" in keys(d) ? d["r"] : nothing
    size = get(d, "s", nothing)
    sip_timestamp = get(d, "t", nothing)
    exchange = d["x"]
    participant_timestamp = "y" in keys(d) ? d["y"] : nothing
    tape = get(d, "z", nothing)
    return LastTrade(
        ticker,
        conditions,
        correction,
        trf_timestamp,
        id,
        price,
        sequence_number,
        trf_id,
        size,
        sip_timestamp,
        exchange,
        participant_timestamp,
        tape
        )
end

include("http_methods.jl")