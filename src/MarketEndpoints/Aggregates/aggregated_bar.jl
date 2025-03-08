struct AggregatedBar <: AbstractBar
    open::Float64
    close::Float64
    high::Float64
    low::Float64
    number::Union{Int64, Nothing}
    timestamp::Int64
    volume::Union{Int64, Nothing}
    weighted_volume::Union{Float64, Nothing}
end

function AggregatedBar(d::Dict{String, Any})
    open = d["o"]
    close = d["c"]
    high = d["h"]
    low = d["l"]
    number = d["n"]
    timestamp = d["t"]
    volume = d["v"]
    weighted_volume = d["vw"]
    return AggregatedBar(
        open,
        close,
        high,
        low,
        number,
        timestamp,
        volume,
        weighted_volume
    )
end