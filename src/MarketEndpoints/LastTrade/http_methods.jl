struct LastTradeResponse
    request_id::Union{String, Nothing}
    results::Union{LastTrade, Nothing}
    status::Union{String, Nothing}
end

function LastTradeResponse(d::Dict{String, Any})
    request_id = get(d, "next_url", nothing)
    results = "results" in keys(d) ? LastTrade(d["results"]) : nothing
    status = get(d, "status", nothing)
    return LastTradeResponse(
        request_id,
        results,
        status
    )
end

function get_raw_last_trade(creds::Credentials, ticker::String)::HTTP.Response
    return HTTP.get(join([endpoint(creds), "v2", "last", "trade", "$(ticker)"], '/'), headers = header(creds))
end

function LastTradeResponse(raw_response::HTTP.Response)
    json_response = Parser.parse(String(raw_response.body))
    return LastTradeResponse(json_response)
end

function DataFrames.DataFrame(last_trade::LastTradeResponse, except_fields::Vector{String}=["results"])
    df = DataFrame(last_trade.results)
    for field in fieldnames(LastTradeResponse)
        if !(String(field) in except_fields)
            metadata!(df, String(field), getproperty(last_trades, field))
        end
    end
    return df
end

function last_trade(creds::Credentials, ticker::String)::Union{LastTradeResponse, DataFrame}

    raw_trade = get_raw_last_trade(creds, ticker)

    if creds.content_type === "text/csv"
        return DataFrame(raw_trade)
    elseif creds.content_type == "application/json"
        return LastTradeResponse(raw_trade)
    end
end
