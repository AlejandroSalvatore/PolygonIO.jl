struct GainersLosersResponse
    count::Union{Int64, Nothing}
    status::Union{String, Nothing}
    tickers::Union{Vector{TickerSnapshot}, Nothing}
    request_id::Union{String, Nothing}
end

function GainersLosersResponse(d::Dict{String, Any})

    count = get(d, "count", nothing)
    status = get(d, "status", nothing)
    tickers = "tickers" in keys(d) ? TickerSnapshot.(d["tickers"]) : nothing
    request_id = get(d, "request_id", nothing)

    return GainersLosersResponse(
        count,
        status,
        tickers,
        request_id
    )
end

function gainers_losers_query(
    include_otc::Union{Bool, Nothing} = false,
    )

    query = Dict()
    include_otc !== nothing ? query["include_otc"] = include_otc : nothing

    return query
end

function get_raw_gainers_losers(
    creds::Credentials,
    direction::Union{GainersLosersDirection, String, Symbol}="gainers";
    include_otc::Union{Bool, Nothing}=false
    )

    parsed_direction = parse_gainers_losers_direction(direction)
    query = gainers_losers_query(include_otc)

    return HTTP.get(join([endpoint(creds), "v2", "snapshot", "locale", "us", "markets", "stocks", parsed_direction], '/'), headers = header(creds), query = query)

end

function DataFrames.DataFrame(gainers_losers::GainersLosersResponse, except_fields::Vector{String}=["tickers"])

    df = DataFrame(gainers_losers.tickers)
    for field in fieldnames(GainersLosersResponse)
        if !(String(field) in except_fields)
            metadata!(df, String(field), getproperty(gainers_losers, field))
        end
    end

    return df

end


function GainersLosersResponse(raw_response::HTTP.Response)

    json_response = Parser.parse(String(raw_response.body))

    return GainersLosersResponse(json_response)
    
end

function gainers_losers(
    creds::Credentials,
    direction::Union{GainersLosersDirection, String, Symbol}="gainers";
    include_otc::Union{Bool, Nothing}=false
    )

    raw_gainers_losers = get_raw_gainers_losers(creds, direction; include_otc)

    if creds.content_type === "text/csv"
        return DataFrame(raw_gainers_losers)
    elseif creds.content_type == "application/json"
        return GainersLosersResponse(raw_gainers_losers)
    end

end
