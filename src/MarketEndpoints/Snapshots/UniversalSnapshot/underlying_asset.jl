struct SnapshotUnderlyingAsset
    change_to_break_even::Union{Float64, Nothing}
    last_updated::Union{Int64, Nothing}
    price::Union{Float64, Nothing}
    ticker::Union{String, Nothing}
    timeframe::Union{String, Nothing}
    value::Union{Float64, Nothing}
end

function SnapshotUnderlyingAsset(d::Dict{String, Any})

    change_to_break_even = get(d, "change_to_break_even", nothing)
    last_updated = get(d, "last_updated", nothing)
    price = get(d, "price", nothing)
    ticker = get(d, "ticker", nothing)
    timeframe = get(d, "timeframe", nothing)
    value = get(d, "value", nothing)

    return SnapshotUnderlyingAsset(
        change_to_break_even,
        last_updated,
        price,
        ticker,
        timeframe,
        value
    )

end