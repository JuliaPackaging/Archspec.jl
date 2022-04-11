module Archspec

using Artifacts
using Pkg
using JSON

const cpu_microarchitectures_json_path = joinpath(only(readdir(artifact"ArchspecJSON"; join=true)), "cpu", "microarchitectures.json")
const cpu_microarchitectures_json = JSON.parsefile(cpu_microarchitectures_json_path)

include("aliases.jl")

struct CompilerSpec
    name::String
    flags::String
    versions::Pkg.Versions.VersionSpec
    warnings::String
end

struct Compiler
    target::String
    name::String
    specs::Vector{CompilerSpec}
end

struct Microarchitecture
    name::String
    features::Set{String}
    compilers::Dict{String,Compiler}
    from::Vector{String}
    vendor::String
end

const CPUTargets = Dict{String,Microarchitecture}()

for (name, microarchitecture) in cpu_microarchitectures_json["microarchitectures"]
    features = Set(microarchitecture["features"])
    compilers = Dict{String,Compiler}()
    from = microarchitecture["from"]
    vendor = microarchitecture["vendor"]

    if haskey(microarchitecture, "compilers")
        for (compiler_name, compiler_specs) in microarchitecture["compilers"]
            specs = CompilerSpec[]
            for spec in compiler_specs
                spec_name = get(spec, "warnings", name)
                ver_low, ver_hi = split(spec["versions"], ':')
                isempty(ver_low) && (ver_low = "0")
                spec_versions = if isempty(ver_hi)
                    Pkg.Versions.semver_spec("≥" * ver_low)
                else
                    Pkg.Versions.semver_spec(ver_low * " - " * ver_hi)
                end
                push!(specs, CompilerSpec(
                    spec_name,
                    replace(spec["flags"], "{name}" => spec_name),
                    spec_versions,
                    get(spec, "warnings", ""),
                ))
            end
            compilers[compiler_name] = Compiler(name, compiler_name, specs)
        end
    end

    CPUTargets[name] = Microarchitecture(name, features, compilers, from, vendor)
end

function augment_features!(m::Microarchitecture)
    _features = deepcopy(m.features)
    for alias in FeatureAliases
        if !isempty(alias.any_of)
            if any(in(alias.any_of), _features)
                push!(_features, alias.name)
            end
        end
        if !isempty(alias.families)
            if any(in(alias.families), m.from)
                push!(_features, alias.name)
            end
        end
    end
    _features
end

"""
    in(feature::String, m::Microarchitecture) -> Bool
    ∈(feature::String, m::Microarchitecture) -> Bool

Return whether the given `feature` is available in the microarchitecture `m`.

```jldoctest
julia> "sse3" in Archspec.CPUTargets["broadwell"]
true

julia> "avx512" in Archspec.CPUTargets["haswell"]
false
```
"""
Base.in(feature::String, m::Microarchitecture) = in(feature, augment_features!(m))

"""
    getindex(c::Compiler, v::VersionNumber)

Return the list of compiler flags for the given compiler version.

```jldoctest
julia> Archspec.CPUTargets["x86_64_v2"].compilers["gcc"][v"5.2"]
"-march=x86_64_v2 -mtune=generic -mcx16 -msahf -mpopcnt -msse3 -msse4.1 -msse4.2 -mssse3"

julia> Archspec.CPUTargets["x86_64_v2"].compilers["gcc"][v"11.1"]
"-march=x86_64_v2 -mtune=generic"
```
"""
function Base.getindex(c::Compiler, v::VersionNumber)
    idx = findfirst(s -> v ∈ s.versions, c.specs)
    if idx === nothing
        error("Version $(v) of $(c.name) is not compatible with the $(c.target) microarchitecture")
    end
    return c.specs[idx].flags
end

for op in (:(==), :(<), :(<=))
    @eval Base.$(op)(a::Microarchitecture, b::Microarchitecture) =
        Base.$(op)(a.features, b.features)
end

end
