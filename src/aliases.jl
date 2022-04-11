struct FeatureAlias
    name::String
    reason::String
    any_of::Vector{String}
    families::Vector{String}
end

const FeatureAliases = Vector{FeatureAlias}()

for (name, alias) in cpu_microarchitectures_json["feature_aliases"]
    reason = alias["reason"]
    any_of = get(alias, "any_of", String[])
    families = get(alias, "families", String[])
    feature = FeatureAlias(name, reason, any_of, families)
    push!(FeatureAliases, feature)
end
