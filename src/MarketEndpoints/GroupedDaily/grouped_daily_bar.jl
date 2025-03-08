function is_date_available(date::Union{Date, String})
    est_time = TimeZone("America/New_York")
    _now = now(est_time)
    _today = Date(_now)
    _now = DateTime(_now)
    if typeof(date) === String
        date = Date(date)
    end
    if date < _today
        return true
    elseif date == _today
        if hour(_now) >= 9 && minute(_now) >= 0
            return true
        else
            return false
        end
    else
        return false
    end
end

struct GroupedDailyBar <: AbstractBar
    ticker::String
    open::Float64
    close::Float64
    high::Float64
    low::Float64
    number::Union{Int64, Float64, Nothing}
    timestamp::Int64
    volume::Union{Int64, Float64, Nothing}
    weighted_volume::Union{Float64, Int64, Nothing}
end

function GroupedDailyBar(d::Dict{String, Any})
    ticker = d["T"]
    open = d["o"]
    close = d["c"]
    high = d["h"]
    low = d["l"]
    number = get(d, "n", nothing)
    timestamp = d["t"]
    volume = get(d, "v", nothing)
    weighted_volume = get(d, "vw", nothing)
    return GroupedDailyBar(
        ticker,
        open,
        close,
        high,
        low,
        number,
        timestamp,
        volume,
        weighted_volume,
    )
end