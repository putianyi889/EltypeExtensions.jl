using Documenter
using EltypeExtensions
using EltypeExtensions: _to_precisiontype, _to_eltype
using Test
using Aqua
using LinearAlgebra

function testelconvert(T, A)
    @test convert_eltype(T, A) isa _to_eltype(T, typeof(A))
end

@testset "elconvert" begin
    A = rand(3,3)
    testelconvert(Float16, A)
    testelconvert(Float16, Symmetric(A))
    testelconvert(Float16, A')
    testelconvert(Float16, transpose(A))
    testelconvert(Float16, SymTridiagonal(Symmetric(A)))
    if VERSION >= v"1.3"
        testelconvert(Float16, UpperHessenberg(A))
    end
    testelconvert(Float16, Hermitian(A))
    testelconvert(Float16, Bidiagonal(A, :U))
    testelconvert(Float16, Bidiagonal(A, :L))
    testelconvert(Float16, Set(A))
    testelconvert(Bool, A .> 0.5)
    testelconvert(Float16, A .> 0.5)
    
    r = 1:5
    testelconvert(Int8, r)
    testelconvert(Float64, r)

    r = 1:1:5
    testelconvert(Int8, r)
    testelconvert(Float64, r)

    inds = CartesianIndex(1,1):CartesianIndex(3,3)
    testelconvert(CartesianIndex{2}, inds)
    testelconvert(Tuple, inds)

    dict = Dict(1=>2)
    testelconvert(Pair{Float64,Float32}, dict)
end

@testset "bugs" begin
    @test _to_precisiontype(Float64, Complex) == Complex{Float64}
    @test convert_precisiontype(BigFloat, rand(ComplexF64, 3)) isa Vector{Complex{BigFloat}}
    
    @testset "#7" begin
        setprecision(256)
        f(x) = convert_precisiontype(BigFloat, x, 256)
        g(x) = convert_precisiontype(BigFloat, x)
        setprecision(128)
        @test precision(f(π)) == 256 # static precision
        @test precision(g(π)) == 128 # precision varies with the global setting
    end

    @testset "#8" begin
        @test convert_precisiontype(Int128, Int8(1)//Int8(2)) isa Rational{Int128}
    end

    @testset "#10" begin
        @test convert_eltype(Int32, 1:5) === Int32(1):Int32(5)
    end

    @testset "#31" begin
        @test convert_eltype(Float64, Diagonal(1:5)) ≡ Diagonal(1.0:5.0)
    end
end

@testset "Misc" begin
    @testset "Moved from DomainSets.jl" begin
        @test convert_eltype(Float64, [1,2]) isa Vector{Float64}
        @test convert_eltype(Float64, [1,2]) == [1,2]
        @test convert_eltype(Float64, Set([1,2])) isa Set{Float64}
        @test convert_eltype(Float64, Set([1,2])) == Set([1,2])
        @test convert_eltype(Float64, 1:5) isa AbstractVector{Float64}
        @test convert_eltype(Float64, 1:5) == 1:5
        @test convert_eltype(Float64, 1) isa Float64
        @test convert_eltype(Float64, 1) == 1

        @test convert_eltype(Float64, Set([1,2])) isa Set{Float64}
        @test convert_eltype(Float64, (1,2)) isa NTuple{2,Float64}
        @test convert_eltype(Int, (1,2)) == (1,2)
    end
end

@testset "Doctest" begin
    doctest(EltypeExtensions)
end

@testset "Aqua" begin
    Aqua.test_all(EltypeExtensions)
end