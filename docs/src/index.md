# EltypeExtensions.jl

EltypeExtensions.jl is a mini toolbox for eltype-related conversions. The motivation of this package comes from manipulating (nested) arrays with different eltypes. However if you have any reasonable idea that works on other instances, feel free to write an issue/pull request.

We note that this package has some overlap with [TypeUtils.jl](https://github.com/emmt/TypeUtils.jl) and [Unitless.jl](https://github.com/emmt/Unitless.jl).

## Guides

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
- `someconvert(T,A)` converts `A` to have the `sometype` of `T`.

where `some` can be `el`, `base` and `precision`.

### On `precisionconvert`
`precisionconvert` accepts an optional third argument `prec`. 
- When `T` has static precision, `prec` has no effect.
- When `T` has dynamic precision, `prec` specifies the precision of conversion. When `prec` is not provided, the precision is decided by the external setup from `T`. The difference is significant when `precisionconvert` is called by another function:
  ```@repl 1
  precision(BigFloat)
  f(x) = precisionconvert(BigFloat, x, precision(BigFloat))
  g(x) = precisionconvert(BigFloat, x)
  setprecision(128)
  f(π) # static precision
  g(π) # precision varies with the global setting
  ```
- When `T` is an integer, the conversion will dig into `Rational` as well. In contrast, since `Rational` as a whole is more "precise" than an integer, `precisiontype` doesn't unwrap `Rational`.
  ```@repl 1
  precisiontype(precisionconvert(Int128, Int8(1)//Int8(2)))
  ```