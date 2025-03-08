struct PreviousCloseResponse
    adjusted::Union{Bool, Nothing}
    query_count::Int32
    request_id::String
    results::Vector{PreviousCloseBar}
    results_count::Int32
    status::String
    ticker::String
end

function PreviousCloseResponse(d::Dict{String, Any})
    adjusted = d["adjusted"]
    query_count = d["queryCount"]
    request_id = d["request_id"]
    results = PreviousCloseBar.(d["results"])
    results_count = d["resultsCount"]
    status = d["status"]
    ticker = d["ticker"]
    return PreviousCloseResponse(
        adjusted,
        query_count,
        request_id,
        results,
        results_count,
        status,
        ticker
    )
end

function previous_close_query(adjusted::Union{Bool, Nothing})
    query = Dict(
        "adjusted" => adjusted === nothing ? nothing : string(adjusted)
    )
    return query


function get_raw_previous_close(
    c::             Credentials,
    stocksTicker:: String;
    adjusted::      Union{Bool, Nothing} = true,
    )::HTTP.Response
    
    query = previous_close_query(adjusted)
    r = HTTP.get(join([endpoint(c), "v2","aggs", "ticker",
    HTTP.URIs.escapeuri(stocksTicker) , "prev"], '/'), 
    query = query, headers = header(c))
    return r
end

function json_previous_close(raw_response::HTTP.Response)
    json_response = JSON.parse(String(raw_response.body))
    return PreviousCloseResponse(json_response)
end

function csv_previous_close(raw_response::HTTP.Response)
    csv_response = IOBuffer(String(raw_response.body))
    df = DataFrame(CSV.File(csv_response))
    df.T = [ticker for _ in 1:length(df.T)]
    # TODO: Include other parts of the response in the metadata
    return df
end