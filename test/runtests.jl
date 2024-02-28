using Documenter
using EltypeExtensions
using Test
using Aqua

@testset "Doctest" begin
    doctest(EltypeExtensions)
end

@testset "Aqua" begin
    Aqua.test_all(EltypeExtensions)
end