```@meta
CurrentModule = Archspec
```

# Archspec

[Archspec](https://github.com/giordano/Archspec.jl) is a [Julia](https://julialang.org/)
package to get access to the information provided by
[`archspec-json`](https://github.com/archspec/archspec-json), part of the
[Archspec](https://github.com/archspec) project.

```@index
```

## CPU Microarchitectures

A CPU microarchitecture is modeled in `Archspec.jl` by the [`Microarchitecture`](@ref)
structure.  Instances of this structure are constructed automatically from `archspec-json`
to populate a dictionary of known microarchitectures:

```@repl
using Archspec
Archspec.CPUTargets
```

`Archspec.CPUTargets` maps the names of the microarchitectures to a corresponding
`Microarchitecture` object:

```jldoctest
julia> using Archspec

julia> Archspec.CPUTargets["broadwell"]
Archspec.Microarchitecture("broadwell", Set(["movbe", "mmx", "sse2", "ssse3", "pclmulqdq", "rdrand", "bmi2", "rdseed", "aes", "avx", "sse4_2", "popcnt", "fma", "avx2", "sse", "sse4_1", "f16c", "bmi1", "adx"]), Dict{String, Archspec.Compiler}("apple-clang" => Archspec.Compiler("broadwell", "apple-clang", Archspec.CompilerSpec[Archspec.CompilerSpec("broadwell", "-march=broadwell -mtune=broadwell", VersionSpec("8.0.0-*"), "")]), "aocc" => Archspec.Compiler("broadwell", "aocc", Archspec.CompilerSpec[Archspec.CompilerSpec("broadwell", "-march=broadwell -mtune=broadwell", VersionSpec("2.2.0-*"), "")]), "intel" => Archspec.Compiler("broadwell", "intel", Archspec.CompilerSpec[Archspec.CompilerSpec("broadwell", "-march=broadwell -mtune=broadwell", VersionSpec("18.0.0-*"), "")]), "gcc" => Archspec.Compiler("broadwell", "gcc", Archspec.CompilerSpec[Archspec.CompilerSpec("broadwell", "-march=broadwell -mtune=broadwell", VersionSpec("4.9.0-*"), "")]), "clang" => Archspec.Compiler("broadwell", "clang", Archspec.CompilerSpec[Archspec.CompilerSpec("broadwell", "-march=broadwell -mtune=broadwell", VersionSpec("3.9.0-*"), "")])), ["haswell"], "GenuineIntel")
```

### Basic queries


A `Microarchitecture` object can be queried for its name and vendor:

```jldoctest
julia> uarch = Archspec.CPUTargets["broadwell"];

julia> uarch.name
"broadwell"

julia> uarch.vendor
"GenuineIntel"
```

A microarchitecture can also be queried for features:

```jldoctest
julia> "avx" ∈ Archspec.CPUTargets["broadwell"]
true

julia> "avx" ∈ Archspec.CPUTargets["thunderx2"]
false

julia> "neon" ∈ Archspec.CPUTargets["thunderx2"]
true
```

The verbatim list of features for each object is stored in the `features` field:

```jldoctest
julia> Archspec.CPUTargets["nehalem"].features
Set{String} with 7 elements:
  "mmx"
  "sse2"
  "ssse3"
  "sse4_2"
  "popcnt"
  "sse"
  "sse4_1"

julia> Archspec.CPUTargets["thunderx2"].features
Set{String} with 11 elements:
  "atomics"
  "evtstrm"
  "sha2"
  "asimdrdm"
  "aes"
  "cpuid"
  "asimd"
  "crc32"
  "sha1"
  "pmull"
  "fp"

julia> Archspec.CPUTargets["power9le"].features
Set{String}()
```

Finally, you can also make set comparison operations between microarchitectures:

```jldoctest
julia> Archspec.CPUTargets["nehalem"] < Archspec.CPUTargets["broadwell"]
true

julia> Archspec.CPUTargets["nehalem"] == Archspec.CPUTargets["broadwell"]
false

julia> Archspec.CPUTargets["nehalem"] >= Archspec.CPUTargets["broadwell"]
false

julia> Archspec.CPUTargets["nehalem"] > Archspec.CPUTargets["a64fx"]
false
```

### Compiler's optimization flags

Another information that each microarchitecture object has available is which compiler flags
needs to be used to emit code optimized for itself:

```jldoctests
julia> Archspec.CPUTargets["broadwell"].compilers["clang"][v"11.0.1"]
"-march=broadwell -mtune=broadwell"
```

Sometimes compiler flags change across versions of the same compiler:

```jldoctests
julia> Archspec.CPUTargets["thunderx2"].compilers["gcc"][v"5.1"]
"-march=armv8-a+crc+crypto"

julia> Archspec.CPUTargets["thunderx2"].compilers["gcc"][v"9.1"]
"-mcpu=thunderx2t99"
```

If a compiler is known to not be able to optimize for a given architecture an exception is
raised:

```jldoctest
julia> Archspec.CPUTargets["icelake"].compilers["gcc"][v"4.8.5"]
ERROR: cannot produce optimized binary for micro-architecture "icelake" with gcc@4.8.5
Stacktrace:
 [1] error(s::String)
   @ Base ./error.jl:33
[...]
```

## API Reference

```@autodocs
Modules = [Archspec]
```
