# EltypeExtensions.jl

EltypeExtensions.jl is a mini toolbox for eltype-related conversions. The motivation of this package comes from manipulating (nested) arrays with different eltypes. However if you have any reasonable idea that works on other instances, feel free to write an issue/pull request.

We note that this package has some overlap with [TypeUtils.jl](https://github.com/emmt/TypeUtils.jl) and [Unitless.jl](https://github.com/emmt/Unitless.jl).

## Introduction

### `convert_eltype` and `_to_eltype`
`convert_eltype(T, x)` works like `convert(T, x)`, except that `T` refers to the eltype of the result. This can be useful for generic codes.

It should be always true that `convert_eltype(T, x) isa _to_eltype(T, typeof(x))`. However, since `convert_eltype` and `_to_eltype` use different routines, it's possible that the equality doesn't hold for some types. Please submit an issue or PR if that happens.

If `typeof(x)` is not in Base or stdlib, the package who owns the type should implement corresponding `_to_eltype` or `convert_eltype`. `convert_eltype` has fallbacks, in which case it could be unnecessary:
- For a subtype of `AbstractArray`, `convert_eltype` calls the constructor `AbstractArray{T}` and `_to_eltype` returns `Array`.
- For a subtype of `AbstractUnitRange`, `convert_eltype` calls the constructor `AbstractUnitRange{T}`.
- For a subtype of `AbstractRange`, `convert_eltype` uses broadcast through `map`.
- For a `Tuple`, `convert_eltype` uses dot broadcast.
- For other types, `convert_eltype` calls `convert` and `_to_eltype`.

However, `_to_eltype` must be implemented for each type to support `convert_basetype` and `convert_precisiontype`. The following types from Base and stdlib are explicitly supported by `_to_eltype`:
```
AbstractArray, AbstractDict, AbstractSet, Adjoint, Bidiagonal, BitArray, CartesianIndices, Diagonal, Dict, Hermitian, Set, StepRangeLen, Symmetric, SymTridiagonal, Transpose, TwicePrecision, UnitRange
```

### `basetype` and `precisiontype`
The `basetype` is used for nested collections, where `eltype` is repeatedly applied until the bottom. `precisiontype` has a similar idea, but goes deeper when possible. `precisiontype` is used to manipulate the accuracy of (nested) collections.
```@setup 1
using EltypeExtensions
```
```@repl 1
basetype(Set{Matrix{Vector{Matrix{Complex{Rational{Int}}}}}})
precisiontype(Set{Matrix{Vector{Matrix{Complex{Rational{Int}}}}}})
```

### Method naming convention
- `sometype(T)` gets the `sometype` of type `T`.
- `sometype(x) = sometype(typeof(x))` is also provided for convenience.
- `_to_sometype(T,S)` converts the type `S` to have the `sometype` of `T`.
- `convert_sometype(T,A)` converts `A` to have the `sometype` of `T`.

where `some` can be `el`, `base` and `precision`.

### On `convert_precisiontype`
`convert_precisiontype` accepts an optional third argument `prec`. 
- When `T` has static precision, `prec` has no effect.
- When `T` has dynamic precision, `prec` specifies the precision of conversion. When `prec` is not provided, the precision is decided by the external setup from `T`. The difference is significant when `convert_precisiontype` is called by another function:
  ```@repl 1
  precision(BigFloat)
  f(x) = convert_precisiontype(BigFloat, x, 256)
  g(x) = convert_precisiontype(BigFloat, x)
  setprecision(128)
  f(π) # static precision
  g(π) # precision varies with the global setting
  ```
- When `T` is an integer, the conversion will dig into `Rational` as well. In contrast, since `Rational` as a whole is more "precise" than an integer, `precisiontype` doesn't unwrap `Rational`.
  ```@repl 1
  precisiontype(convert_precisiontype(Int128, Int8(1)//Int8(2)))
  ```

## Notable behaviours

### Ranges
Ranges in Julia are not consistently processed:
```@repl 1
r = StepRange(1,1,5)
Float64.(r) |> typeof
map(Float64,r) |> typeof
```
We adapt `_to_eltype` to the return type of `Base.map`:
```@repl 1
_to_eltype(Float64, StepRange{Int,Int})
```