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

function get_date(format::String="yyyy-mm-dd")
    return Dates.format(get_time(), format)
end

function filter_timestamp(filter)
    if filter === ">"
        return "timestamp.gt"
    elseif filter === ">="
        return "timestamp.gte"
    elseif filter === "<"
        return "timestamp.lt"
    elseif filter === "<="
        return "timestamp.lte"
    else
        return "timestamp"
    end
end

