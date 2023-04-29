module PolygonAPI

export credentials
using Reexport
using HTTP, JSON, TimesDates, Dates

#= Abstract -> EndPoint =#
abstract type EndPoint end
##
struct LIVE <: EndPoint end 
##

#= EndPoint -> PolygonApi =#
EndPoint(::Type{T}) where {T<:EndPoint} = T == LIVE ? "https://api.polygon.io" : nothing

#= Credentials =# 
struct Credentials 
    ENDPOINT::Type{T} where {T<:EndPoint}
    KEY_ID::String
    REAL_TIME::Union{Bool, Nothing}
    MAX_RANGE::Union{Int64, Nothing}
end

#= Environment -> Credentials =#
credentials() = Credentials(
    getproperty(PolygonAPI, Symbol(ENV["POLY_API_ENDPOINT"])),
    ENV["POLY_API_KEY_ID"],
    parse(Bool, ENV["POLY_REAL_TIME"]),
    parse(Int, ENV["POLY_MAX_RANGE"])
)

credentials(key_id::String) = Credentials(LIVE, key_id, nothing, nothing)


#= Credentials -> PolygonApi =#
HEADER(c::Credentials) = Dict("Authorization"=>join(["Bearer", c.KEY_ID], " "))
function HEADER(c::Credentials, csv::Bool)
    if csv
        return Dict("Authorization"=>join(["Bearer", c.KEY_ID], " "), "Accept" => "text/csv")
    else
        return Dict("Authorization"=>join(["Bearer", c.KEY_ID], " "))
    end
end
    
ENDPOINT(c::Credentials)::String = EndPoint(c.ENDPOINT)

include("./utils.jl")
include("./MarketEndpoints/MarketEndpoints.jl")
include("./ReferenceEndpoints/ReferenceEndpoints.jl")

end

