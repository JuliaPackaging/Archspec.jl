using Archspec
using Test

using Archspec: Microarchitecture

@testset "Archspec.jl" begin
    @test Archspec.CPUTargets["x86_64"] isa Microarchitecture

    # Compilation flags
    @test_throws ErrorException Archspec.CPUTargets["x86_64_v3"].compilers["gcc"][v"4.7"]
    @test Archspec.CPUTargets["x86_64_v3"].compilers["gcc"][v"5.2"] ==
        "-march=x86_64_v3 -mtune=generic -mcx16 -msahf -mpopcnt -msse3 -msse4.1 -msse4.2 -mssse3 -mavx -mavx2 -mbmi -mbmi2 -mf16c -mfma -mlzcnt -mmovbe -mxsave"
    @test Archspec.CPUTargets["x86_64_v3"].compilers["gcc"][v"11.1"] ==
        "-march=x86_64_v3 -mtune=generic"

    # Features
    @test "avx" ∈ Archspec.CPUTargets["broadwell"]
    @test "avx" ∉ Archspec.CPUTargets["thunderx2"]
    # Aliases
    @test "avx512" ∈ Archspec.CPUTargets["skylake_avx512"]
    @test "neon" ∈ Archspec.CPUTargets["thunderx2"]
    # Aliases are not available when in the `features` field of the microarchitecture
    @test "avx512" ∉ Archspec.CPUTargets["skylake_avx512"].features
    @test "neon" ∉ Archspec.CPUTargets["thunderx2"].features
    # Comparisons
    @test Archspec.CPUTargets["x86_64_v2"] == Archspec.CPUTargets["x86_64_v2"]
    @test Archspec.CPUTargets["x86_64_v2"] != Archspec.CPUTargets["x86_64"]
    @test Archspec.CPUTargets["x86_64_v3"] <  Archspec.CPUTargets["x86_64_v4"]
    @test Archspec.CPUTargets["x86_64_v4"] >  Archspec.CPUTargets["x86_64_v2"]
    @test Archspec.CPUTargets["x86_64"]    <= Archspec.CPUTargets["x86_64_v2"]
    @test Archspec.CPUTargets["x86_64_v4"] >= Archspec.CPUTargets["x86_64_v3"]
end
