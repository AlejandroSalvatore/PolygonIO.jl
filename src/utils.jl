export dictify

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

function yesterday()
    td = get_time()
    ytd = td - Dates.Day(1)
    return ytd
end

function date_available(date)
    datetime = DateTime(date)
    datedate = DateTime(get_date())

    if datetime == datedate

        tdy = get_time()
        tdy_opening = DateTime(join([get_date(), "T", "09:01:00.000"], ""))

        if tdy < tdy_opening
            return false
        end
    else
        return true
    end
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

function dictify(object)
    dict = Dict(key=>getfield(object, key) for key ∈ fieldnames(typeof(object)))
    return dict
end

