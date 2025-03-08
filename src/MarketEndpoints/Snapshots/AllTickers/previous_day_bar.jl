struct TickerPreviousDayBar <: AbstractBar
    close::Union{Float64, Nothing}
    high::Union{Float64, Nothing}
    low::Union{Float64, Nothing}
    open::Union{Float64, Nothing}
    volume::Union{Float64, Int64, Nothing}
    weighted_volume::Union{Float64, Nothing}
end

function TickerPreviousDayBar(d::Dict{String, Any})

    close = get(d, "c", nothing)
    high = get(d, "h", nothing)
    low = get(d, "l", nothing)
    open = get(d, "o", nothing)
    volume = get(d, "v", nothing)
    weighted_volume = get(d, "vw", nothing)

    return TickerPreviousDayBar(
        close,
        high,
        low,
        open,
        volume,
        weighted_volume
    )
    
end






    