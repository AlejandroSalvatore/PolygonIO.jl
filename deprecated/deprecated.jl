

# This is the key for the api
KEY = "s2Sl5GoOibf4wEICr2LJ2oQn_w3paeLK"


function get_api_url(key::String)
    api_url = "&apiKey="*key
    return api_url
end

export KEY_URL 
KEY_URL = get_api_url(KEY)


function get_response(response)
    json = JSON.Parser.parse(String(response.body)) 
    return json
end


function get_time(url::String="")
    if length(url) != 0
        pol_time = HTTP.request("GET", url)
        json = get_response(pol_time)
        time = json["serverTime"]
        time = time[1:length(time)-6]
        return DateTime(time)
    else    
        est_time = TimeZone("America/New_York")
        time = now(est_time)
        return DateTime(time)
    end
end


function get_stocks_info()
    response = get_response(HTTP.request("GET", "https://api.polygon.io/v3/reference/tickers?type=CS&market=stocks&active=true&sort=ticker&order=asc&limit=1000&apiKey=Yu5Fm1NoakFcAQ5e7L_ghNIGOiqjq632"))
    results = response["results"]
    while "next_url" in keys(response)
        next_url = response["next_url"]
        response = get_response(HTTP.request("GET", next_url*KEY_URL))
        results_next = response["results"]
        append!(results, results_next)
    end
    return results
end


function get_tickers(stocks_info::Vector{Any})
    tickers = [stock["ticker"] for stock in stocks_info]
    return tickers
end

DATE_FIN = get_time()
MAX_DATE = Dates.Year(10)
DATE_INI = DATE_FIN - MAX_DATE
DATE_FIN_DEF = Dates.format(DATE_FIN, "yyyy-mm-dd")
DATE_INI_DEF = Dates.format(DATE_INI, "yyyy-mm-dd")


function default_dict(ticker, timestamp)
    DEFAULT_DICT = Dict("ticker" => ticker, "v" => 0, "c" => 0, "o" => 0, "t" => timestamp, "l" => 0, "h" => 0)
    return DEFAULT_DICT
end


function get_snapshot(ticker, multiplier, timespan, date_ini, date_end)
    try
        response = get_response(HTTP.request("GET", "https://api.polygon.io/v2/aggs/ticker/$ticker/range/$multiplier/$timespan/$date_ini/$date_end?adjusted=true&sort=desc&limit=50000&apiKey=Yu5Fm1NoakFcAQ5e7L_ghNIGOiqjq632"))
        results = response["results"]
        println("The ticker $ticker has been requested successfuly")
        snap = [Dict("ticker" => ticker, "o" => day["o"], "c" => day["c"], "l" => day["l"], "h" => day["h"], "v" => day["v"], "t" => day["t"]) for day in results]
        return snap
    catch e
        println("Error $e found. Ignoring ticker $ticker...")
        return "Failed"
    end
end


function get_snapshots(tickers, multiplier, timespan, date_ini, date_end)
    snapshots = map(ticker -> get_snapshot(ticker, multiplier, timespan, date_ini, date_end), tickers)
    return snapshots
end


INFO = get_stocks_info()
TICKERS = get_tickers(INFO)
SNAPSHOTS = get_snapshots(TICKERS, 1, "day", DATE_INI_DEF, DATE_FIN_DEF)


function clean_snapshots!(snapshots, tickers)
    to_delete = findall(snapshot->snapshot=="Failed", snapshots)
    splice!(snapshots, to_delete)
    splice!(tickers, to_delete)
end


clean_snapshots!(SNAPSHOTS, TICKERS)


function fill_snapshots!(snapshots_cleaned)
    max_len = maximum([length(snapshot) for snapshot in snapshots_cleaned])
    max_arg = argmax([length(snapshot) for snapshot in snapshots_cleaned])
    timestamps = [day["t"] for day in snapshots_cleaned[max_arg]]
    for snapshot in snapshots_cleaned
        if length(snapshot) < max_len
            missing_timestamps = timestamps[length(snapshot)+1:end]
            filler = [default_dict(snapshot[1]["ticker"], timestamp) for timestamp in missing_timestamps]
            append!(snapshot, filler)
        end
    end
    return timestamps
end


export TIMESTAMPS
TIMESTAMPS = fill_snapshots!(SNAPSHOTS)


function get_attribute(snapshots_filled, attribute)
    att_array = [[day[attribute] for day in snapshot] for snapshot in snapshots_filled]
    return att_array
end


function add_attribute(snapshots_filled, att_list, att_name)
    [[day[att_name] = att_list[snapshot[1]] for day in snapshot[2]] for snapshot in enumerate(snapshots_filled)]
    return snapshots_filled
end


function remove_attribute(snapshots, att_name)
    [[delete!(day, att_name) for day in snapshot] for snapshot in snapshots]
    return snapshots
end


function populate_df(snapshots)
    snapshots_df = DataFrame()
    [append!(snapshots_df, snapshot) for snapshot in snapshots]
    return snapshots_df
end

export DF 
DF = populate_df(SNAPSHOTS)

function df_to_csv(df, path, filename)
    CSV.write("$path$filename.csv", df)
end


df_to_csv(DF, "/Users/alejandro.vasquez/Julia_projects", "/data_df")


function from_dict_to_array(snapshots_filled)
    snapshots = [[[day["o"] day["c"] day["h"] day["l"] day["t"] day["v"]] for day in snapshot] for snapshot in snapshots_filled]
    return snapshots
end

# export SNAPSHOTS_ARRAY
# SNAPSHOTS_ARRAY = from_dict_to_array(SNAPSHOTS)


function locate_inner_length(n, snapshots)
    location = []
    for snapshot in enumerate(snapshots)
        for day in enumerate(snapshot[2])
            length(keys(day[2])) == n ? push!(location, [snapshot[1], day[1]]) : nothing
        end
    end
    return location
end