export AggregatesSort

const AGGREGATES_SORT = Dict(
    "asc" => "Ascending",
    "desc" => "Descending"
)

@enum AggregatesSort begin
    Ascending
    Descending
end

function parse_aggregates_sort(sort::Union{AggregatesSort, String, Symbol}, default::String="asc")::String
    parsed_sort = sort |> string |> lowercase
    if parsed_sort in values(AGGREGATES_SORT)
        return parsed_sort
    elseif parsed_sort in keys(AGGREGATES_SORT)
        return AGGREGATES_SORT[parsed_sort]
    else
        @warn "The content type '$parsed_sort' is not valid. It was set by default to '$default'." 
        return default
    end
end