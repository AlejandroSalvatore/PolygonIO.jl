struct SnapshotSession
    change::Union{Float64, Nothing}
    change_percent::Union{Float64, Nothing}
    close::Union{Float64, Nothing}
    early_trading_change::Union{Float64, Nothing}
    early_trading_change_percent::Union{Float64, Nothing}
    high::Union{Float64, Nothing}
    late_trading::Union{Float64, Nothing}
    late_trading_percent::Union{Float64, Nothing}
    low::Union{Float64, Nothing}
    open::Union{Float64, Nothing}
    previous_close::Union{Float64, Nothing}
    price::Union{Float64, Nothing}
    regular_trading_change::Union{Float64, Nothing}
    regular_trading_change_percent::Union{Float64, Nothing}
    volume::Union{Float64, Nothing}
end

function SnapshotSession(d::Dict{String, Any})

    change = get(d, "change", nothing)
    change_percent = get(d, "change_percent", nothing)
    close = get(d, "close", nothing)
    early_trading_change = get(d, "early_trading_change", nothing)
    early_trading_change_percent = get(d, "early_trading_change_percent", nothing)
    high = get(d, "high", nothing)
    late_trading = get(d, "late_trading", nothing)
    late_trading_percent = get(d, "late_trading_percent", nothing)
    low = get(d, "low", nothing)
    open = get(d, "open", nothing)
    previous_close = get(d, "previous_close", nothing)
    price = get(d, "price", nothing)
    regular_trading_change = get(d, "regular_trading_change", nothing)
    regular_trading_change_percent = get(d, "regular_trading_change_percent", nothing)
    volume = get(d, "volume", nothing)

    return SnapshotSession(
        change,
        change_percent,
        close,
        early_trading_change,
        early_trading_change_percent,
        high,
        late_trading,
        late_trading_percent,
        low,
        open,
        previous_close,
        price,
        regular_trading_change,
        regular_trading_change_percent,
        volume
    )

end