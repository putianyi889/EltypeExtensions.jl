using Documenter
using EltypeExtensions
using EltypeExtensions: _to_precisiontype
using Test
using Aqua

@testset "bugs" begin
    @test _to_precisiontype(Float64, Complex) == Complex{Float64}
    @test precisionconvert(BigFloat, rand(ComplexF64, 3)) isa Vector{Complex{BigFloat}}
end

@testset "Doctest" begin
    doctest(EltypeExtensions)
end

@testset "Aqua" begin
    Aqua.test_all(EltypeExtensions)
end