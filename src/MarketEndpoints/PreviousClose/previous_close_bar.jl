struct PreviousCloseBar <: AbstractBar
    ticker::String
    close::Float32
    high::Float32
    low::Float32
    open::Float32
    timestamp::Int64
    volume::Int64
    weighted_volume::Float32
end

function PreviousCloseBar(d::Dict{String, Union{String, Float32, Int64}})
    ticker = d["T"]
    close = d["c"]
    high = d["h"]
    low = d["l"]
    open = d["o"]
    timestamp = d["t"]//1000
    volume = d["v"]
    weighted_volume = d["vw"]
    return PreviousCloseBar(
        ticker,
        close,
        high,
        low,
        open,
        timestamp,
        volume,
        weighted_volume
    )
end
