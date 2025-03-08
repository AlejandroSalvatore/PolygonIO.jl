struct SnapshotDetails
    contract_type::Union{String, Nothing}
    excercise_style::Union{String, Nothing}
    expiration_date::Union{Date, String, Nothing}
    shares_per_contract::Union{Float64, Nothing}
    strike_price::Union{Float64, Nothing}
    underlying_ticker::Union{String, Nothing}
end

function SnapshotDetails(d::Dict{String, Any})

    contract_type = get(d, "contract_type", nothing)
    excercise_style = get(d, "excercise_style", nothing)
    expiration_date = get(d, "expiration_date", nothing)
    shares_per_contract = get(d, "shares_per_contract", nothing)
    strike_price = get(d, "strike_price", nothing)
    underlying_ticker = get(d, "underlying_ticker", nothing)

    return SnapshotDetails(
        contract_type,
        excercise_style,
        expiration_date,
        shares_per_contract,
        strike_price,
        underlying_ticker
    )

end