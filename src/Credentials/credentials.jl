export Credentials
export header
export endpoint

include("abstracts.jl")
include("content_type.jl")

struct Credentials <: AbstractCredentials
    api_key::String
    endpoint::String
    content_type::String;
    max_range::Union{Int8, Nothing}
    real_time::Union{Bool, Nothing}
end

function Credentials()::Credentials
    API_KEY = get(ENV, "POLYGON_IO_API_KEY", missing)
    if API_KEY === missing
        throw(error("You have not defined your POLYGON_API_KEY"))
    else
        return Credentials(API_KEY, ENDPOINT, CONTENT_TYPE, MAX_RANGE, REAL_TIME)
    end
end
    
function Credentials(api_key::String)::Credentials
    Credentials(api_key, ENDPOINT, CONTENT_TYPE, MAX_RANGE, REAL_TIME)
end

function Credentials(api_key::String, content_type::Union{Symbol, String})::Credentials
    c_type = parse_content_type(content_type)
    return Credentials(api_key, ENDPOINT, c_type, MAX_RANGE, REAL_TIME)
end

header(c::Credentials)::Dict = Dict("Authorization"=>join(["Bearer", c.api_key], " "), "Accept" => c.content_type)
endpoint(c::Credentials)::String = c.endpoint