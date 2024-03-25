# EltypeExtensions

[![Build Status](https://github.com/putianyi889/EltypeExtensions.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/putianyi889/EltypeExtensions.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://putianyi889.github.io/EltypeExtensions.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://putianyi889.github.io/EltypeExtensions.jl/dev)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![codecov](https://codecov.io/gh/putianyi889/EltypeExtensions.jl/branch/master/graph/badge.svg?label=codecov)](https://codecov.io/gh/putianyi889/EltypeExtensions.jl)

EltypeExtensions.jl is a mini toolbox for eltype-related conversions. The motivation of this package comes from manipulating (nested) arrays with different eltypes. However if you have any reasonable idea that works on other instances, feel free to write an issue/pull request.

We note that this package has some overlap with [TypeUtils.jl](https://github.com/emmt/TypeUtils.jl) and [Unitless.jl](https://github.com/emmt/Unitless.jl).

## Introduction

### `elconvert` and `_to_eltype`
`elconvert(T, x)` works like `convert(T, x)`, except that `T` refers to the eltype of the result. This can be useful for generic codes.

It should be always true that `elconvert(T, x) isa _to_eltype(T, typeof(x))`. However, since `elconvert` and `_to_eltype` use different routines, it's possible that the equality doesn't hold for some types. Please submit an issue or PR if that happens.

If `typeof(x)` is not in Base or stdlib, the package who owns the type should implement corresponding `_to_eltype` or `elconvert`. `elconvert` has fallbacks, in which case it could be unnecessary:
- For a subtype of `AbstractArray`, `elconvert` calls the constructor `AbstractArray{T}` and `_to_eltype` returns `Array`.
- For a subtype of `AbstractUnitRange`, `elconvert` calls the constructor `AbstractUnitRange{T}`.
- For a subtype of `AbstractRange`, `elconvert` uses broadcast through `map`.
- For a `Tuple`, `elconvert` uses dot broadcast.
- For other types, `elconvert` calls `convert` and `_to_eltype`.

However, `_to_eltype` must be implemented for each type to support `baseconvert` and `precisionconvert`. The following types from Base and stdlib are explicitly supported by `_to_eltype`:
```
AbstractArray, AbstractDict, AbstractSet, Adjoint, Bidiagonal, BitArray,
CartesianIndices, Diagonal, Dict, Hermitian, Set, StepRangeLen, Symmetric,
SymTridiagonal, Transpose, TwicePrecision, UnitRange
```

### `basetype` and `precisiontype`
The `basetype` is used for nested collections, where `eltype` is repeatedly applied until the bottom. `precisiontype` has a similar idea, but goes deeper when possible. `precisiontype` is used to manipulate the accuracy of (nested) collections.

### Method naming convention
- `sometype(T)` gets the `sometype` of type `T`.
- `sometype(x) = sometype(typeof(x))` is also provided for convenience.
- `_to_sometype(T,S)` converts the type `S` to have the `sometype` of `T`.
- `someconvert(T,A)` converts `A` to have the `sometype` of `T`.

where `some` can be `el`, `base` and `precision`.

### On `precisionconvert`
`precisionconvert` accepts an optional third argument `prec`. 
- When `T` has static precision, `prec` has no effect.
- When `T` has dynamic precision, `prec` specifies the precision of conversion. When `prec` is not provided, the precision is decided by the external setup from `T`. The difference is significant when `precisionconvert` is called by another function. See the document for an example.
- When `T` is an integer, the conversion will dig into `Rational` as well. In contrast, since `Rational` as a whole is more "precise" than an integer, `precisiontype` doesn't unwrap `Rational`.
