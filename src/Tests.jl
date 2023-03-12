ENV["POLY_API_ENDPOINT"] = "LIVE"
ENV["POLY_API_KEY_ID"] = "s2Sl5GoOibf4wEICr2LJ2oQn_w3paeLK"
ENV["POLY_REAL_TIME"] = true
ENV["POLY_MAX_RANGE"] = 10

include("PolygonApi.jl")
c = PolygonApi.credentials()


function get_all_tickers(c)
    data = PolygonApi.g
end