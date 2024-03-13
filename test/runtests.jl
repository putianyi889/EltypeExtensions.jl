using Documenter
using EltypeExtensions
using EltypeExtensions: _to_precisiontype
using Test
using Aqua

@testset "bugs" begin
    @test _to_precisiontype(Float64, Complex) == Complex{Float64}
    @test precisionconvert(BigFloat, rand(ComplexF64, 3)) isa Vector{Complex{BigFloat}}
    
    @testset "#7" begin
        setprecision(256)
        f(x) = precisionconvert(BigFloat, x, 256)
        g(x) = precisionconvert(BigFloat, x)
        setprecision(128)
        @test precision(f(π)) == 256 # static precision
        @test precision(g(π)) == 128 # precision varies with the global setting
    end

    @testset "#8" begin
        @test precisionconvert(Int128, Int8(1)//Int8(2)) isa Rational{Int128}
    end
end

@testset "Doctest" begin
    doctest(EltypeExtensions)
end

@testset "Aqua" begin
    Aqua.test_all(EltypeExtensions)
end