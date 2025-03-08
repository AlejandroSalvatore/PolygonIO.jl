export Bar

struct Bar <: AbstractBar
    open::Float32
    close::Float32
    high::Float32
    low::Float32
    number::Union{Float64, Nothing}
    timestamp::DateTime
    volume::Union{Number, Nothing}
    weighted_volume::Union{Float32, Nothing}
    timespan::String
    adjusted::Bool
    ticker::String
end

function _Bar(d::Dict{String, Any})::Bar
    ticker = get(d, "T", nothing)
    open = d["o"]
    close = d["c"]
    high = d["h"]
    low = d["l"]
    number = get(d, "n", 0)
    timestamp = unix2datetime(d["t"]//1000)
    volume = get(d, "v", 0)
    weighted_volume = get(d, "vw", 0)
    otc = "otc" in keys(d) ? true : false
    timespan = get(d, "timespan", "day")
    return Bar(ticker, open, close, high, low, number, timestamp, volume, weighted_volume, otc, timespan)
end

function Bar(d::Dict{Symbol, Any})::Bar
    ticker = d[:ticker]
    open = d[:open]
    close = d[:close]
    high = d[:high]
    low = d[:low]
    number = d[:number]
    timestamp = d[:timestamp]
    volume = d[:volume]
    weighted_volume = d[:weighted_volume]
    otc = d[:otc]
    timespan = d[:timespan]
    return Bar(ticker, open, close, high, low, number, timestamp, volume, weighted_volume, otc, timespan)
end

function Bar(df_row::DataFrameRow)
    weighted_volume = df_row.weighted_volume
    timestamp = df_row.timestamp
    otc = df_row.otc
    close = df_row.close
    volume = df_row.volume
    open = df_row.open
    timespan = df_row.timespan
    high = df_row.high
    ticker = df_row.ticker
    low = df_row.low
    number = df_row.number
    return Bar(ticker, open, close, high, low, number, timestamp, volume, weighted_volume, otc, timespan)
end