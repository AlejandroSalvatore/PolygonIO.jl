struct SnapshotGreeks
    delta::Union{Float64, Nothing}
    gamma::Union{Float64, Nothing}
    theta::Union{Float64, Nothing}
    vega::Union{Float64, Nothing}
end

function SnapshotGreeks(d::Dict{String, Nothing})

    delta = get(d, "delta", nothing)
    gamma = get(d, "gamma", nothing)
    theta = get(d, "theta", nothing)
    vega = get(d, "vega", nothing)

    return SnapshotGreeks(
        delta,
        gamma,
        theta,
        vega
    )

end

