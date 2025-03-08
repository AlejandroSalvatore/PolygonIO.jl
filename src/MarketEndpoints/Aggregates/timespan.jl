export AggregatesTimespan

const AGGREGATE_TIMESPANS = ["second", "minute", "hour", "day", "week", "month", "quarter", "year"]

@enum AggregatesTimespan begin
    Second
    Minute
    Hour
    Day
    Week
    Month
    Quarter
    Year
end

function parse_aggregates_timespan(timespan::Union{AggregatesTimespan, String, Symbol}, default::String="day")::String
    parsed_timespan = timespan |> string |> lowercase
    if parsed_timespan in AGGREGATE_TIMESPANS
        return parsed_timespan
    else
        @warn "The content type '$parsed_timespan' is not valid. It was set by default to '$default'." 
        return default
    end
end
