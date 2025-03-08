struct MostRecentMinuteBar <: AbstractBar
    accumulated_volume::Union{Int64, Nothing}
    close::Union{Float64, Nothing}
    high::Union{Float64, Nothing}
    low::Union{Float64, Nothing}
    number::Union{Int64, Nothing}
    open::Union{Float64, Nothing}
    otc::Union{Bool, Nothing}
    timestamp::Union{Int64, Nothing}
    volume::Union{Float64, Nothing}
    weighted_volume::Union{Float64, Nothing}
end

function MostRecentMinuteBar(d::Dict{String, Any})

    accumulated_volume = get(d, "av", nothing)
    close = get(d, "c", nothing)
    high = get(d, "h", nothing)
    low = get(d, "l", nothing)
    number = get(d, "n", nothing)
    open = get(d, "o", nothing)
    otc = get(d, "otc", nothing)
    timestamp = get(d, "t", nothing)
    volume = get(d, "v", nothing)
    weighted_volume = get(d, "vw", nothing)

    return MostRecentMinuteBar(
        accumulated_volume,
        close,
        high,
        low,
        number,
        open,
        otc,
        timestamp,
        volume,
        weighted_volume
    )
    
end