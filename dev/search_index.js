var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = Archspec","category":"page"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = quote\nusing Archspec\nend","category":"page"},{"location":"#Archspec","page":"Home","title":"Archspec","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Archspec is a Julia package to get access to the information provided by archspec-json, part of the Archspec project.","category":"page"},{"location":"#CPU-Microarchitectures","page":"Home","title":"CPU Microarchitectures","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A CPU microarchitecture is modeled in Archspec.jl by the Microarchitecture structure.  Instances of this structure are constructed automatically from archspec-json to populate a dictionary of known microarchitectures:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Archspec\nArchspec.CPUTargets","category":"page"},{"location":"","page":"Home","title":"Home","text":"Archspec.CPUTargets maps the names of the microarchitectures to a corresponding Microarchitecture object:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using Archspec\n\njulia> Archspec.CPUTargets[\"broadwell\"]\nArchspec.Microarchitecture(\"broadwell\", Set([\"movbe\", \"mmx\", \"sse2\", \"ssse3\", \"pclmulqdq\", \"rdrand\", \"bmi2\", \"rdseed\", \"aes\", \"avx\", \"sse4_2\", \"popcnt\", \"fma\", \"avx2\", \"sse\", \"sse4_1\", \"f16c\", \"bmi1\", \"adx\"]), Dict{String, Archspec.Compiler}(\"apple-clang\" => Archspec.Compiler(\"broadwell\", \"apple-clang\", Archspec.CompilerSpec[Archspec.CompilerSpec(\"broadwell\", \"-march=broadwell -mtune=broadwell\", VersionSpec(\"8.0.0-*\"), \"\")]), \"aocc\" => Archspec.Compiler(\"broadwell\", \"aocc\", Archspec.CompilerSpec[Archspec.CompilerSpec(\"broadwell\", \"-march=broadwell -mtune=broadwell\", VersionSpec(\"2.2.0-*\"), \"\")]), \"intel\" => Archspec.Compiler(\"broadwell\", \"intel\", Archspec.CompilerSpec[Archspec.CompilerSpec(\"broadwell\", \"-march=broadwell -mtune=broadwell\", VersionSpec(\"18.0.0-*\"), \"\")]), \"gcc\" => Archspec.Compiler(\"broadwell\", \"gcc\", Archspec.CompilerSpec[Archspec.CompilerSpec(\"broadwell\", \"-march=broadwell -mtune=broadwell\", VersionSpec(\"4.9.0-*\"), \"\")]), \"clang\" => Archspec.Compiler(\"broadwell\", \"clang\", Archspec.CompilerSpec[Archspec.CompilerSpec(\"broadwell\", \"-march=broadwell -mtune=broadwell\", VersionSpec(\"3.9.0-*\"), \"\")])), [\"haswell\"], \"GenuineIntel\")","category":"page"},{"location":"#Basic-queries","page":"Home","title":"Basic queries","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A Microarchitecture object can be queried for its name and vendor:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> uarch = Archspec.CPUTargets[\"broadwell\"];\n\njulia> uarch.name\n\"broadwell\"\n\njulia> uarch.vendor\n\"GenuineIntel\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"A microarchitecture can also be queried for features:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> \"avx\" ∈ Archspec.CPUTargets[\"broadwell\"]\ntrue\n\njulia> \"avx\" ∈ Archspec.CPUTargets[\"thunderx2\"]\nfalse\n\njulia> \"neon\" ∈ Archspec.CPUTargets[\"thunderx2\"]\ntrue","category":"page"},{"location":"","page":"Home","title":"Home","text":"The verbatim list of features for each object is stored in the features field:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> Archspec.CPUTargets[\"nehalem\"].features\nSet{String} with 7 elements:\n  \"mmx\"\n  \"sse2\"\n  \"ssse3\"\n  \"sse4_2\"\n  \"popcnt\"\n  \"sse\"\n  \"sse4_1\"\n\njulia> Archspec.CPUTargets[\"thunderx2\"].features\nSet{String} with 11 elements:\n  \"atomics\"\n  \"evtstrm\"\n  \"sha2\"\n  \"asimdrdm\"\n  \"aes\"\n  \"cpuid\"\n  \"asimd\"\n  \"crc32\"\n  \"sha1\"\n  \"pmull\"\n  \"fp\"\n\njulia> Archspec.CPUTargets[\"power9le\"].features\nSet{String}()","category":"page"},{"location":"","page":"Home","title":"Home","text":"Finally, you can also make set comparison operations between microarchitectures:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> Archspec.CPUTargets[\"nehalem\"] < Archspec.CPUTargets[\"broadwell\"]\ntrue\n\njulia> Archspec.CPUTargets[\"nehalem\"] == Archspec.CPUTargets[\"broadwell\"]\nfalse\n\njulia> Archspec.CPUTargets[\"nehalem\"] >= Archspec.CPUTargets[\"broadwell\"]\nfalse\n\njulia> Archspec.CPUTargets[\"nehalem\"] > Archspec.CPUTargets[\"a64fx\"]\nfalse","category":"page"},{"location":"#Compiler's-optimization-flags","page":"Home","title":"Compiler's optimization flags","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Another information that each microarchitecture object has available is which compiler flags needs to be used to emit code optimized for itself:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> optimization_flags(Archspec.CPUTargets[\"broadwell\"], \"clang\", v\"11.0.1\")\n\"-march=broadwell -mtune=broadwell\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Sometimes compiler flags change across versions of the same compiler:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> optimization_flags(Archspec.CPUTargets[\"thunderx2\"], \"gcc\", v\"5.1\")\n\"-march=armv8-a+crc+crypto\"\n\njulia> optimization_flags(Archspec.CPUTargets[\"thunderx2\"], \"gcc\", v\"9.1\")\n\"-mcpu=thunderx2t99\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"If a compiler is known to not be able to optimize for a given architecture an exception is raised:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> optimization_flags(Archspec.CPUTargets[\"icelake\"], \"gcc\", v\"4.8.5\")\nERROR: cannot produce optimized binary for micro-architecture \"icelake\" with gcc@4.8.5\nStacktrace:\n [1] error(s::String)\n   @ Base ./error.jl:33\n[...]","category":"page"},{"location":"#API-Reference","page":"Home","title":"API Reference","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Archspec]","category":"page"},{"location":"#Archspec.Compiler","page":"Home","title":"Archspec.Compiler","text":"Compiler\n\nCompiler is a composite structure modeling a compiler for a given microarchitecture.\n\n\n\n\n\n","category":"type"},{"location":"#Archspec.CompilerSpec","page":"Home","title":"Archspec.CompilerSpec","text":"CompilerSpec\n\nCompilerSpec is a composite structure modeling an instance of a compiler for a given microarchitecture and a specific version number, or range of versions.\n\n\n\n\n\n","category":"type"},{"location":"#Archspec.Microarchitecture","page":"Home","title":"Archspec.Microarchitecture","text":"Microarchitecture\n\nMicroarchitecture is a composite structure modeling a CPU microarchitecture.\n\n\n\n\n\n","category":"type"},{"location":"#Archspec.optimization_flags-Tuple{Archspec.Microarchitecture, String, VersionNumber}","page":"Home","title":"Archspec.optimization_flags","text":"optimization_flags(microarchitecture::Microarchitecture, compiler::String, version::VersionNumber)\n\nReturn the list of compiler flags for the given micro-architecture using the given compiler version.\n\njulia> optimization_flags(Archspec.CPUTargets[\"x86_64_v2\"], \"gcc\", v\"5.2\")\n\"-march=x86_64_v2 -mtune=generic -mcx16 -msahf -mpopcnt -msse3 -msse4.1 -msse4.2 -mssse3\"\n\njulia> optimization_flags(Archspec.CPUTargets[\"x86_64_v2\"], \"gcc\", v\"11.1\")\n\"-march=x86_64_v2 -mtune=generic\"\n\n\n\n\n\n","category":"method"},{"location":"#Base.in-Tuple{String, Archspec.Microarchitecture}","page":"Home","title":"Base.in","text":"in(feature::String, m::Microarchitecture) -> Bool\n∈(feature::String, m::Microarchitecture) -> Bool\n\nReturn whether the given feature is available in the microarchitecture m.\n\njulia> \"sse3\" in Archspec.CPUTargets[\"broadwell\"]\ntrue\n\njulia> \"avx512\" in Archspec.CPUTargets[\"haswell\"]\nfalse\n\n\n\n\n\n","category":"method"}]
}
