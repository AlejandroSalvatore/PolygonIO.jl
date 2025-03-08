export GainersLosersDirection

const GAINERS_LOSERS_DIRECTIONS = Dict(
    "g" => "gainers",
    "l" => "losers"
)

@enum GainersLosersDirection begin
    Gainers
    Losers
end

function parse_gainers_losers_direction(direction::Union{GainersLosersDirection, String, Symbol}, default::String="gainers")::String
    parsed_direction = direction |> string |> lowercase
    if parsed_direction in values(GAINERS_LOSERS_DIRECTIONS)
        return parsed_direction
    elseif parsed_direction in keys(GAINERS_LOSERS_DIRECTIONS)
        return GAINERS_LOSERS_DIRECTIONS[parsed_direction]
    else
        @warn "The Gainers/Losers direction '$parsed_direction' is not valid. It was set by default to '$default'." 
        return default
    end
end