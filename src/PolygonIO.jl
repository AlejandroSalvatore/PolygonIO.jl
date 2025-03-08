module PolygonIO

const ENDPOINT = get(ENV, "POLYGON_IO_ENDPOINT", "https://api.polygon.io")
const REAL_TIME = parse(Bool, get(ENV, "POLYGON_IO_REAL_TIME", "false"))
const MAX_RANGE = parse(Int, get(ENV, "POLYGON_IO_MAX_RANGE", "5"))
const CONTENT_TYPE = get(ENV, "POLYGON_IO_CONTENT_TYPE", "application/json")


using HTTP, JSON, TimesDates, Dates, DataFrames, CSV
using Dates: Date
using JSON: Parser

include("./Credentials/credentials.jl")
include("./MarketEndpoints/market_endpoints.jl")
include("./ReferenceEndpoints/reference_endpoints.jl")
include("./Utils/utils.jl")

end

