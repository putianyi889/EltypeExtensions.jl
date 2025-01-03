module EltypeExtensions

import Base: convert, TwicePrecision
using LinearAlgebra # to support 1.0, not using package extensions
import LinearAlgebra: AbstractQ

export convert_eltype, basetype, convert_basetype, precisiontype, convert_precisiontype

@static if VERSION >= v"1.3"
    _to_eltype(::Type{T}, ::Type{UpperHessenberg{S,M}}) where {T,S,M} = UpperHessenberg{T,_to_eltype(T,M)}
    convert_eltype(::Type{T}, A::UpperHessenberg{S,M}) where {T,S,M} = UpperHessenberg{T,_to_eltype(T,M)}(A)
end
@static if VERSION >= v"1.5"
    @inline bigfloatconvert(x, prec) = BigFloat(x, precision = prec)
else
    @inline bigfloatconvert(x, prec) = BigFloat(x, prec)
end
@static if VERSION >= v"1.9"
    convert_eltype(::Type{T}, A::S) where {T,S<:Bidiagonal} = convert(_to_eltype(T, S), A)
else
    convert_eltype(::Type{T}, A::Bidiagonal{S,V}) where {T,S,V} = Bidiagonal{T,_to_eltype(T,V)}(A.dv, A.ev, A.uplo)
end
@static if VERSION >= v"1.10"
    convert_eltype(::Type{T}, A::AbstractQ) where T = convert(AbstractQ{T}, A) # see https://github.com/JuliaLang/julia/pull/46196
end

"""
    convert_eltype(T, A)

Similar to `convert(T, A)`, but `T` refers to the eltype. See also [`_to_eltype`](@ref).

# Examples
```jldoctest; setup = :(using EltypeExtensions: convert_eltype)
julia> convert_eltype(Float64, 1:10)
1.0:1.0:10.0

julia> typeof(convert_eltype(Float64, rand(Int, 3, 3)))
$(repr("text/plain", Matrix{Float64}))
```
"""
convert_eltype(::Type{T}, A::S) where {T,S} = convert(_to_eltype(T, S), A)
convert_eltype(::Type{T}, A::AbstractRange) where T = map(T, A)
convert_eltype(::Type{T}, A::AbstractUnitRange) where T<:Integer = convert(AbstractUnitRange{T}, A)
convert_eltype(::Type{T}, A::Tuple) where T = convert.(T, A)
convert_eltype(::Type{T}, A::Set{T}) where T = A
convert_eltype(::Type{T}, A::Set) where T = Set(convert.(T, A))

"""
    _to_eltype(T, S)

Convert type `S` to have the `eltype` of `T`. See also [`convert_eltype`](@ref).
"""
_to_eltype(::Type{T}, ::Type{S}) where {T,S} = eltype(S) == S ? T : eltype(S) == T ? S : MethodError(_to_eltype, T, S)
_to_eltype(::Type{T}, ::Type{<:AbstractArray{S,N}}) where {T,S,N} = AbstractArray{T,N}
_to_eltype(::Type{T}, ::Type{<:AbstractSet}) where T = AbstractSet{T}
_to_eltype(::Type{Pair{K,V}}, ::Type{<:AbstractDict}) where {K,V} = AbstractDict{K,V}
_to_eltype(::Type{Pair{K,V}}, ::Type{<:Dict}) where {K,V} = Dict{K,V}

_to_eltype(::Type{T}, ::Type{Array{S,N}}) where {T,S,N} = Array{T,N}
_to_eltype(::Type{T}, ::Type{<:Set}) where T = Set{T}
_to_eltype(::Type{T}, ::Type{<:TwicePrecision}) where T = TwicePrecision{T}

_to_eltype(::Type{T}, ::Type{BitArray}) where T = Array{T}
_to_eltype(::Type{T}, ::Type{BitArray{N}}) where {T,N} = Array{T,N}
_to_eltype(::Type{Bool}, ::Type{BitArray}) = BitArray
_to_eltype(::Type{Bool}, ::Type{BitArray{N}}) where N = BitArray{N}

_to_eltype(::Type{T}, ::Type{Bidiagonal}) where T = Bidiagonal{T}
_to_eltype(::Type{T}, ::Type{Bidiagonal{S}}) where {T,S} = Bidiagonal{T}
_to_eltype(::Type{T}, ::Type{Bidiagonal{S,M}}) where {T,S,M} = Bidiagonal{T,_to_eltype(T,M)}

for TYP in (Adjoint, Diagonal, Hermitian, Symmetric, SymTridiagonal, Transpose)
    @eval _to_eltype(::Type{T}, ::Type{$TYP}) where T = $TYP{T}
    @eval _to_eltype(::Type{T}, ::Type{$TYP{S}}) where {T,S} = $TYP{T}
    @eval _to_eltype(::Type{T}, ::Type{$TYP{S,M}}) where {T,S,M} = $TYP{T,_to_eltype(T,M)}
    if TYP == SymTridiagonal
        @eval convert_eltype(::Type{T}, A::SymTridiagonal) where {T} = SymTridiagonal(convert_eltype(T, A.dv), convert_eltype(T, A.ev))
    else
        @eval convert_eltype(::Type{T}, A::$TYP) where {T} = $TYP(convert_eltype(T, parent(A)))
    end
end

@static if VERSION >= v"1.6"
    _to_eltype(::Type{CartesianIndex{N}}, ::Type{CartesianIndices{N,R}}) where {N, R<:Tuple{Vararg{OrdinalRange{Int64, Int64}, N}}} = CartesianIndices{N,R}
else
    _to_eltype(::Type{CartesianIndex{N}}, ::Type{CartesianIndices{N,R}}) where {N, R<:Tuple{Vararg{AbstractUnitRange{Int64},N}}} = CartesianIndices{N,R}
end
_to_eltype(::Type{T}, ::Type{<:CartesianIndices}) where T = Array{T}

@static if VERSION >= v"1.7"
    _to_eltype(::Type{T}, ::Type{<:StepRangeLen}) where T<:Real = StepRangeLen{T,_to_eltype(T,TwicePrecision),_to_eltype(T,TwicePrecision),Int}
    _to_eltype(::Type{T}, ::Type{<:StepRange}) where T<:AbstractFloat = StepRangeLen{T,_to_eltype(T,TwicePrecision),_to_eltype(T,TwicePrecision),Int}
else
    _to_eltype(::Type{T}, ::Type{<:StepRangeLen}) where T<:Real = StepRangeLen{T,_to_eltype(T,TwicePrecision),_to_eltype(T,TwicePrecision)}
    _to_eltype(::Type{T}, ::Type{<:StepRange}) where {T<:AbstractFloat} = StepRangeLen{T,_to_eltype(T,TwicePrecision),_to_eltype(T,TwicePrecision)}
end
_to_eltype(::Type{T}, ::Type{<:StepRange}) where {T<:Real} = StepRange{T,T} # technically, it is better to preserve the step type. The current implementation follows from `Base.map(::Type{T}, r::StepRange) where {T<:Real}`.
_to_eltype(::Type{T}, ::Type{<:UnitRange}) where T<:Integer = UnitRange{T}
_to_eltype(::Type{T}, ::Type{<:UnitRange}) where T<:Real = _to_eltype(T, StepRangeLen)

nutype(x) = nutype(typeof(x))
nutype(T::Type) = throw(MethodError(nutype, T))

"""
    basetype(T::Type)

Recursively apply `eltype` to `T` until convergence.

# Examples
```jldoctest; setup = :(using EltypeExtensions: basetype)
julia> basetype(Matrix{BitArray})
Bool

julia> basetype(Vector{Set{Complex{Float64}}})
$(repr("text/plain", Complex{Float64}))

julia> basetype([1:n for n in 1:10])
Int64
```
"""
basetype(x) = basetype(typeof(x))
basetype(::Type{T}) where T = eltype(T) == T ? T : basetype(eltype(T))

"""
    _to_basetype(T::Type, S::Type)

Convert type `S` to have the [`basetype`](@ref) of `T`.
"""
_to_basetype(::Type{T}, ::Type{S}) where {T,S} = eltype(S) == S ? T : _to_eltype(_to_basetype(T, eltype(S)), S)

"""
    convert_basetype(T::Type, A)

Similar to `convert(T, A)`, but `T` refers to the [`basetype`](@ref).
"""
convert_basetype(::Type{T}, A::S) where {T,S} = convert(_to_basetype(T,S), A)

"""
    precisiontype(T::Type)

Returns the type that decides the precision of `T`. The difference from [`basetype`](@ref) is that `precisiontype` unwraps composite basetypes such as `Complex` and that `precisiontype` is not generalised.

# Examples
```jldoctest; setup = :(using EltypeExtensions: precisiontype)
julia> precisiontype(Complex{Float32})
Float32

julia> precisiontype(Matrix{ComplexF64})
Float64
```
"""
precisiontype(x) = precisiontype(typeof(x))
precisiontype(::Type{T}) where T<:Real = T
precisiontype(::Type{Complex{T}}) where T = T
precisiontype(::Type{T}) where T = eltype(T) == T ? throw(MethodError(precisiontype, T)) : precisiontype(basetype(T))

"""
    _to_precisiontype(T::Type, S::Type)

Convert type `S` to have the [`precisiontype`](@ref) of `T`. An exception is that if `T<:Integer`, then `Rational` will also be unwrapped.

# Examples
```jldoctest; setup = :(using EltypeExtensions: _to_precisiontype)
julia> _to_precisiontype(Float64, Complex{Rational{Int}})
$(repr("text/plain", Complex{Float64}))

julia> _to_precisiontype(BigFloat, Matrix{Complex{Bool}})
$(repr("text/plain", Matrix{Complex{BigFloat}}))

julia> _to_precisiontype(Int, Complex{Rational{BigInt}})
Complex{Rational{Int64}}
```
"""
_to_precisiontype(::Type{T}, ::Type{Complex}) where T = Complex{T}
_to_precisiontype(::Type{T}, ::Type{Complex{S}}) where {T,S} = Complex{_to_precisiontype(T,S)}
_to_precisiontype(::Type{T}, ::Type{<:Rational}) where T<:Integer = Rational{T}
_to_precisiontype(::Type{T}, ::Type{S}) where {T,S} = eltype(S) == S ? T : _to_eltype(_to_precisiontype(T, eltype(S)), S)

"""
    convert_precisiontype(T::Type, A, prec)

Convert `A` to have the [`precisiontype`](@ref) of `T`. `prec` is optional.
- When `T` has static precision (e.g. `Float64`), `prec` has no effect.
- When `T` has dynamic precision (e.g. `BigFloat`), `prec` specifies the precision of conversion. When `prec` is not provided, the precision is decided by the external setup from `T`.
- When `T` is an integer, the conversion will dig into `Rational` as well. In contrast, since `Rational` as a whole is more "precise" than an integer, [`precisiontype`](@ref) doesn't unwrap `Rational`.

# Examples
```jldoctest; setup = :(using EltypeExtensions: convert_precisiontype)
julia> convert_precisiontype(BigFloat, 1//3+im, 128)
$(repr(bigfloatconvert(1//3, 128))) + 1.0im

julia> convert_precisiontype(Float16, [[m/n for n in 1:3] for m in 1:3])
3-element $(repr(Vector{Vector{Float16}})):
 [1.0, 0.5, 0.3333]
 [2.0, 1.0, 0.6665]
 [3.0, 1.5, 1.0]
```
"""
convert_precisiontype(::Type{T}, A::S) where {T,S} = convert(_to_precisiontype(T,S), A)
convert_precisiontype(::Type{T}, A::S, prec) where {T,S} = convert_precisiontype(T, A)
convert_precisiontype(::Type{BigFloat}, A::S) where {S} = convert(_to_precisiontype(BigFloat,S), A)
convert_precisiontype(::Type{BigFloat}, x::Real, prec) = bigfloatconvert(x, prec)
convert_precisiontype(::Type{BigFloat}, x::Complex, prec) = Complex(bigfloatconvert(real(x), prec), bigfloatconvert(imag(x), prec))
convert_precisiontype(::Type{BigFloat}, A, prec) = convert_precisiontype.(BigFloat, A, prec)

include("deprecated.jl")

end
