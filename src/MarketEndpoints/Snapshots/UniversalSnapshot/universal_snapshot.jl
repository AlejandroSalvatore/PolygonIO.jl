include("details.jl")
include("greeks.jl")
include("last_quote.jl")
include("last_trade.jl")
include("session.jl")
include("underlying_asset.jl")

struct UniversalSnapshot <: AbstractSnapshot
    break_even_price::Union{Float64, Nothing}
    details::Union{SnapshotDetails, Nothing}
    fmv::Union{Float64, Nothing}
    greeks::Union{SnapshotGreeks, Nothing}
    implied_volatility::Union{Float64, Nothing}
    last_quote::Union{SnapshotLastQuote, Nothing}
    last_trade::Union{SnapshotLastTrade, Nothing}
    market_status::Union{String, Nothing}
    message::Union{String, Nothing}
    name::Union{String, Nothing}
    open_interest::Union{Float64, Nothing}
    session::Union{SnapshotSession, Nothing}
    ticker::Union{String, Nothing}
    type::Union{String, Nothing}
    underlying_asset::Union{SnapshotUnderlyingAsset, Nothing}
    value::Union{Float64, Nothing}
end

function UniversalSnapshot(d::Dict{String, Any})

    break_even_price = get(d, "break_even_price", nothing)
    details = "details" in keys(d) ? SnapshotDetails(d["details"]) : nothing
    fmv = get(d, "fmv", nothing)
    greeks = "greeks" in keys(d) ? SnapshotGreeks(d["greeks"]) : nothing
    implied_volatility = get(d, "implied_volatility", nothing)
    last_quote = "last_quote" in keys(d) ? SnapshotLastQuote(d["last_quote"]) : nothing
    last_trade = "last_trade" in keys(d) ? SnapshotLastTrade(d["last_trade"]) : nothing
    market_status = get(d, "market_status", nothing)
    message = get(d, "message", nothing)
    name = get(d, "name", nothing)
    open_interest = get(d, "open_interest", nothing)
    session = "session" in keys(d) ? SnapshotSession(d["session"]) : nothing
    ticker = get(d, "ticker", nothing)
    type = get(d, "type", nothing)
    underlying_asset = "underlying_asset" in keys(d) ? SnapshotUnderlyingAsset(d["underlying_asset"]) : nothing
    value = get(d, "value", nothing)

    return UniversalSnapshot(
        break_even_price,
        details,
        fmv,
        greeks,
        implied_volatility,
        last_quote,
        last_trade,
        market_status,
        message,
        name,
        open_interest,
        session,
        ticker,
        type,
        underlying_asset,
        value
    )

end

include("http_methods.jl")