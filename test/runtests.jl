using Archspec
using Test

using Archspec: CPUTargets, Microarchitecture

@testset "Archspec.jl" begin
    @test Archspec.CPUTargets["x86_64"] isa Microarchitecture

    # Compilation flags
    @test_throws ErrorException optimization_flags(CPUTargets["x86_64"], "non-existing-compiler", v"0")
    @test_throws ErrorException optimization_flags(CPUTargets["x86_64_v3"], "gcc", v"4.7")
    @test optimization_flags(CPUTargets["x86_64_v3"], "gcc", v"5.2") ==
        "-march=x86_64_v3 -mtune=generic -mcx16 -msahf -mpopcnt -msse3 -msse4.1 -msse4.2 -mssse3 -mavx -mavx2 -mbmi -mbmi2 -mf16c -mfma -mlzcnt -mmovbe -mxsave"
    @test optimization_flags(CPUTargets["x86_64_v3"], "gcc", v"11.1") ==
        "-march=x86_64_v3 -mtune=generic"

    # Features
    @test "avx" ∈ CPUTargets["broadwell"]
    @test "avx" ∉ CPUTargets["thunderx2"]
    # Aliases
    @test "avx512" ∈ CPUTargets["skylake_avx512"]
    @test "neon" ∈ CPUTargets["thunderx2"]
    # Aliases are not available when in the `features` field of the microarchitecture
    @test "avx512" ∉ CPUTargets["skylake_avx512"].features
    @test "neon" ∉ CPUTargets["thunderx2"].features
    # Comparisons
    @test CPUTargets["x86_64_v2"] == CPUTargets["x86_64_v2"]
    @test CPUTargets["x86_64_v2"] != CPUTargets["x86_64"]
    @test CPUTargets["x86_64_v3"] <  CPUTargets["x86_64_v4"]
    @test CPUTargets["x86_64_v4"] >  CPUTargets["x86_64_v2"]
    @test CPUTargets["x86_64"]    <= CPUTargets["x86_64_v2"]
    @test CPUTargets["x86_64_v4"] >= CPUTargets["x86_64_v3"]
end
