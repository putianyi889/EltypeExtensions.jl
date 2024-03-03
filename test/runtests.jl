using Documenter
using EltypeExtensions
using EltypeExtensions: _to_precisiontype
using Test
using Aqua
using ContinuumArrays

@testset "bugs" begin
    @test _to_precisiontype(Float64, Complex) == Complex{Float64}
    @test precisionconvert(BigFloat, Inclusion(-1..1)) isa Inclusion{BigFloat}
end

@testset "Doctest" begin
    doctest(EltypeExtensions)
end

@testset "Aqua" begin
    Aqua.test_all(EltypeExtensions)
end