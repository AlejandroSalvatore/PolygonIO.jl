struct SnapshotLastTrade
    conditions::Union{Vector{Int64}, Nothing}
    exchange::Union{Int64, Nothing}
    id::Union{String, Nothing}
    last_updated::Union{Int64, Nothing}
    participant_timestamp::Union{Int64, Nothing}
    price::Union{Float64, Nothing}
    sip_timestamp::Union{Int64, Nothing}
    size::Union{Float64, Nothing}
    timeframe::Union{String, Nothing}
end

function SnapshotLastTrade(d::Dict{String, Any})

    conditions = get(d, "conditions", nothing)
    exchange = get(d, "exchange", nothing)
    id = get(d, "id", nothing)
    last_updated = get(d, "last_updated", nothing)
    participant_timestamp = get(d, "participant_timestamp", nothing)
    price = get(d, "price", nothing)
    sip_timestamp = get(d, "sip_timestamp", nothing)
    size = get(d, "size", nothing)
    timeframe = get(d, "timeframe", nothing)

    return SnapshotLastTrade(
        conditions,
        exchange,
        id,
        last_updated,
        participant_timestamp,
        price,
        sip_timestamp,
        size,
        timeframe
    )

end
