export ContentType

const CONTENT_TYPES = Dict(
    "csv" => "text/csv",
    "json" => "application/json"
)

@enum ContentType Json Csv

function parse_content_type(type::Union{ContentType, String, Symbol}, default::String="application/json")::String
    parsed_type = type |> string |> lowercase
    if parsed_type in values(CONTENT_TYPES)
        return parsed_type
    elseif parsed_type in keys(CONTENT_TYPES)
        return CONTENT_TYPES[parsed_type]
    else
        @warn "The content type '$parsed_type' is not valid. It was set by default to '$default'." 
        return default
    end
end