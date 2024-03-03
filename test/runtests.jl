using Documenter
using EltypeExtensions
using EltypeExtensions: _to_precisiontype
using Test
using Aqua

@testset "bugs" begin
    @test _to_precisiontype(Float64, Complex) == Complex{Float64}
end

@testset "Doctest" begin
    doctest(EltypeExtensions)
end

@testset "Aqua" begin
    Aqua.test_all(EltypeExtensions)
end