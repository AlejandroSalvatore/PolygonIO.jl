struct TickerSnapshot
    day::Union{MostRecentDailyBar, Nothing}
    last_trade::Union{TickerLastTrade, Nothing}
    min::Union{String, MostRecentMinuteBar, Nothing}
    previous_day::Union{TickerPreviousDayBar, Nothing}
    last_quote::Union{TickerLastQuote, Nothing}
    ticker::Union{String, Nothing}
    todays_change::Union{Float64, Nothing}
    todays_change_perc::Union{Float64, Nothing}
    updated::Union{Int64, Nothing}
end

function TickerSnapshot(d::Dict{String, Any})
    
    day = "day" in keys(d) ? MostRecentDailyBar(d["day"]) : nothing
    last_trade = "lastTrade" in keys(d) ? TickerLastTrade(d["lastTrade"]) : nothing
    last_quote = "lastQuote" in keys(d) ? TickerLastQuote(d["lastQuoute"]) : nothing
    min = "min" in keys(d) ? MostRecentMinuteBar(d["min"]) : nothing
    previous_day = "prevDay" in keys(d) ? TickerPreviousDayBar(d["prevDay"]) : nothing
    ticker = get(d, "ticker", nothing)
    todays_change = get(d, "todaysChange", nothing)
    todays_change_perc = get(d, "todaysChangePerc", nothing)
    updated = get(d, "updated", nothing)

    return TickerSnapshot(
        day,
        last_trade,
        min,
        previous_day,
        last_quote,
        ticker,
        todays_change,
        todays_change_perc,
        updated
    )

end