struct TickerSnapshotResponse
    count::Union{Int64, Nothing}
    status::Union{String, Nothing}
    ticker::Union{TickerSnapshot, Nothing}
    request_id::Union{String, Nothing}
end

function TickerSnapshotResponse(d::Dict{String, Any})

    count = get(d, "count", nothing)
    status = get(d, "status", nothing)
    ticker = "ticker" in keys(d) ? TickerSnapshot(d["ticker"]) : nothing
    request_id = get(d, "request_id", nothing)

    return TickerSnapshotResponse(
        count,
        status,
        ticker,
        request_id
    )

end

function get_raw_ticker_snapshot(
    creds::Credentials,
    ticker::String,
    )

    return HTTP.get(join([endpoint(creds), "v2", "snapshot", "locale", "us", "markets", "stocks", "tickers", ticker], '/'), headers = header(creds))

end

function DataFrames.DataFrame(ticker_response::TickerSnapshotResponse, except_fields::Vector{String}=["ticker"])

    df = DataFrame(ticker_response.ticker)
    for field in fieldnames(TickerSnapshotResponse)
        if !(String(field) in except_fields)
            metadata!(df, String(field), getproperty(ticker_response, field))
        end
    end

    return df

end

function TickerSnapshotResponse(raw_response::HTTP.Response)

    json_response = Parser.parse(String(raw_response.body))
    
    return TickerSnapshotResponse(json_response)

end

function ticker_snapshot(
    creds::Credentials,
    ticker::String,
    )

    raw_ticker_snap = get_raw_ticker_snapshot(creds, ticker)

    if creds.content_type === "text/csv"
        return DataFrame(raw_ticker_snap)
    elseif creds.content_type == "application/json"
        return TickerSnapshotResponse(raw_ticker_snap)
    end

end