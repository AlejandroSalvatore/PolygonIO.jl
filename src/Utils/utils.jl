# export write
# export get_ticker_bars
# export InnerFilling
# export OuterFilling
# export fill!
# export fill 

# import Base.fill!
# import Base.fill
# import Base.length

# function write(filename::String, objects::Vector{String})
#     f = open(filename, "w")
#     for object in objects
#         Base.write(f, object)
#         Base.write(f, "\n")
#     end
#     close(f)
# end

# function get_ticker_bars(tickers::Vector{String})
#     stocks = []
#     for ticker in tickers
#         bar = bars(creds, ticker, 1, PolygonIO.Day, "2018-12-29", "2023-12-29", info=true)
#         append!(stocks, bar)
#     end
#     return stocks
# end

@enum InnerFilling begin
    Latest
    Earliest
end

@enum OuterFilling begin
    Full
    Past
    Future
end


function timespan_delta_func(timespan::AggregatesTimespan)
    func_name = timespan |> string
    func_name = split(func_name, ".")[end]
    func_name = Symbol(func_name)
    delta_func = getfield(Dates, func_name)
    return delta_func
end

function DataFrames.DataFrame(raw_response::HTTP.Response)
    csv_response = IOBuffer(String(raw_response.body))
    df = DataFrame(CSV.File(csv_response))
    return df
end

# function check_delta(bar_1::Bar, bar_2::Bar, how::InnerFilling=Earliest)
#     delta_func = timespan_delta_func(bar_1.timespan)
#     init_date = bar_1.timestamp
#     end_date = bar_2.timestamp
#     if how === Earliest
#         delta = end_date - init_date
#     else
#         delta = init_date - end_date
#     end
#     if delta >= delta_func(2)
#         return true
#     else
#         return false
#     end
# end


# function create_delta(bar::Bar, new_timestamp)::Bar
#     new_bar = Bar(bar.ticker, bar.open, bar.close, bar.high, bar.low, 
#             bar.number, new_timestamp, bar.volume, bar.weighted_volume,
#             bar.otc, bar.timespan)
#     return new_bar
# end


# function Base.fill(bars::TickerBars, how::InnerFilling)
#     values = deepcopy(bars.values)
#     timespan = values[1].timespan
#     order = bars.order
#     delta_func = timespan_delta_func(timespan)
#     if how === Earliest && order === Descending || how === Latest && order === Ascending
#         reverse!(values)
#     end
#     if how === Earliest
#         delta = delta_func(1)
#     else
#         delta = - delta_func(1)
#     end
#     i = 1
#     while true
#         init_bar = values[i]
#         end_bar = get(values, i+1, nothing)
#         if end_bar === nothing
#             break
#         end
#         condition = check_delta(init_bar, end_bar, how)
#         if condition
#             new_timestamp = init_bar.timestamp + delta
#             new_bar = create_delta(init_bar, new_timestamp)
#             splice!(values, i+1:i, [new_bar])
#         end
#         i += 1
#     end
#     return TickerBars(values, order)
# end


# # function Base.fill!(list_bars::Vector{TickerBars}, how::InnerFilling)
# #     for bars in list_bars
# #         fill!(bars, how)
# #     end
# # end

# function Base.length(bars::AbstractBars)
#     return length(bars.values)
# end

# function Base.fill(bars::TickerBars, date::Union{String, Date, DateTime}, how::OuterFilling)
#     date = DateTime(date)
#     timespan = bars.values[1].timespan
#     delta_func = timespan_delta_func(timespan)
#     values = deepcopy(bars.values)
#     if how === Future
#         max_date = date
#         min_date = maximum([bar.timestamp for bar in values])
#         timestamps = min_date+delta_func(1):delta_func(1):max_date+delta_func(1)
#     elseif how == Past
#         min_date = date
#         max_date = minimum([bar.timestamp for bar in values])
#         timestamps = min_date:delta_func(1):max_date-delta_func(1)
#     end
#     filler_bars = [Bar(values[1].ticker, 0, 0, 0, 0, 0, timestamp, 0, 0, values[1].otc, timespan) for timestamp in timestamps]
#     append!(values, filler_bars)
#     return TickerBars(values, bars.order)
# end


# # function Base.fill!(list_bars::Vector{TickerBars}, date::Union{String, Date}, how::OuterFilling)
# #     for bars in list_bars
# #         fill!(bars, date, how)
# #     end
# # end


# function dictify(object)
#     dict = Dict(key=>getfield(object, key) for key ∈ fieldnames(typeof(object)))
#     return dict
# end
