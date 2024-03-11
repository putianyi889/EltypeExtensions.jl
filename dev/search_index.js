var documenterSearchIndex = {"docs":
[{"location":"docstring/#Docstrings","page":"Docstrings","title":"Docstrings","text":"","category":"section"},{"location":"docstring/","page":"Docstrings","title":"Docstrings","text":"Modules = [EltypeExtensions]","category":"page"},{"location":"docstring/#EltypeExtensions._to_basetype-Union{Tuple{S}, Tuple{T}, Tuple{Type{T}, Type{S}}} where {T, S}","page":"Docstrings","title":"EltypeExtensions._to_basetype","text":"_to_basetype(T::Type, S::Type)\n\nConvert type S to have the basetype of T.\n\n\n\n\n\n","category":"method"},{"location":"docstring/#EltypeExtensions._to_eltype-Union{Tuple{N}, Tuple{S}, Tuple{T}, Tuple{Type{T}, Type{Array{S, N}}}} where {T, S, N}","page":"Docstrings","title":"EltypeExtensions._to_eltype","text":"_to_eltype(T, S)\n\nConvert type S to have the eltype of T.\n\n\n\n\n\n","category":"method"},{"location":"docstring/#EltypeExtensions._to_precisiontype-Union{Tuple{T}, Tuple{Type{T}, Type{Complex}}} where T","page":"Docstrings","title":"EltypeExtensions._to_precisiontype","text":"_to_precisiontype(T::Type, S::Type)\n\nConvert type S to have the precisiontype of T. An exception is that if T<:Integer, then Rational will also be unwrapped.\n\nExamples\n\njulia> _to_precisiontype(Float64, Complex{Rational{Int}})\nComplexF64 (alias for Complex{Float64})\n\njulia> _to_precisiontype(BigFloat, Matrix{Complex{Bool}})\nMatrix{Complex{BigFloat}} (alias for Array{Complex{BigFloat}, 2})\n\njulia> _to_precisiontype(Int, Complex{Rational{BigInt}})\nComplex{Rational{Int64}}\n\n\n\n\n\n","category":"method"},{"location":"docstring/#EltypeExtensions.baseconvert-Union{Tuple{S}, Tuple{T}, Tuple{Type{T}, S}} where {T, S}","page":"Docstrings","title":"EltypeExtensions.baseconvert","text":"baseconvert(T::Type, A)\n\nSimilar to convert(T, A), but T refers to the basetype.\n\n\n\n\n\n","category":"method"},{"location":"docstring/#EltypeExtensions.basetype-Tuple{Any}","page":"Docstrings","title":"EltypeExtensions.basetype","text":"basetype(T::Type)\n\nRecursively apply eltype to T until convergence.\n\nExamples\n\njulia> basetype(Matrix{BitArray})\nBool\n\njulia> basetype(Vector{Set{Complex{Float64}}})\nComplexF64 (alias for Complex{Float64})\n\njulia> basetype([1:n for n in 1:10])\nInt64\n\n\n\n\n\n","category":"method"},{"location":"docstring/#EltypeExtensions.elconvert-Union{Tuple{T}, Tuple{Type{T}, AbstractArray}} where T","page":"Docstrings","title":"EltypeExtensions.elconvert","text":"elconvert(T, A)\n\nSimilar to convert(T, A), but T refers to the eltype.\n\nExamples\n\njulia> elconvert(Float64, 1:10)\n1.0:1.0:10.0\n\njulia> typeof(elconvert(Float64, rand(Int, 3, 3)))\nMatrix{Float64} (alias for Array{Float64, 2})\n\n\n\n\n\n","category":"method"},{"location":"docstring/#EltypeExtensions.precisionconvert-Tuple{Any, Any}","page":"Docstrings","title":"EltypeExtensions.precisionconvert","text":"precisionconvert(T::Type, A, prec=precision(T))\n\nConvert A to have the precisiontype of T. If T has adjustable precision such as BigFloat, the precision can be specified by prec, otherwise prec takes no effect.\n\nExamples\n\njulia> precisionconvert(BigFloat, 1//3+im, 128)\n0.3333333333333333333333333333333333333338 + 1.0im\n\njulia> precisionconvert(Float16, [[m/n for n in 1:3] for m in 1:3])\n3-element Vector{Vector{Float16}}:\n [1.0, 0.5, 0.3333]\n [2.0, 1.0, 0.6665]\n [3.0, 1.5, 1.0]\n\n\n\n\n\n","category":"method"},{"location":"docstring/#EltypeExtensions.precisiontype-Tuple{Any}","page":"Docstrings","title":"EltypeExtensions.precisiontype","text":"precisiontype(T::Type)\n\nReturns the type that decides the precision of T. The difference from basetype is that precisiontype unwraps composite basetypes such as Complex and that precisiontype is not generalised.\n\nExamples\n\njulia> precisiontype(Complex{Float32})\nFloat32\n\njulia> precisiontype(Matrix{ComplexF64})\nFloat64\n\n\n\n\n\n","category":"method"},{"location":"#EltypeExtensions.jl","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"","category":"section"},{"location":"","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"EltypeExtensions.jl is a mini toolbox for eltype-related conversions. The motivation of this package comes from manipulating (nested) arrays with different eltypes. However if you have any reasonable idea that works on other instances, feel free to write an issue/pull request.","category":"page"},{"location":"","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"We note that this package has some overlap with TypeUtils.jl and Unitless.jl.","category":"page"},{"location":"#Guides","page":"EltypeExtensions.jl","title":"Guides","text":"","category":"section"},{"location":"#basetype-and-precisiontype","page":"EltypeExtensions.jl","title":"basetype and precisiontype","text":"","category":"section"},{"location":"","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"The basetype is used for nested collections, where eltype is repeatedly applied until the bottom. precisiontype has a similar idea, but goes deeper when possible. precisiontype is used to manipulate the accuracy of (nested) collections.","category":"page"},{"location":"","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"using EltypeExtensions","category":"page"},{"location":"","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"basetype(Set{Matrix{Vector{Matrix{Complex{Rational{Int}}}}}})\nprecisiontype(Set{Matrix{Vector{Matrix{Complex{Rational{Int}}}}}})","category":"page"},{"location":"#Method-naming-convention","page":"EltypeExtensions.jl","title":"Method naming convention","text":"","category":"section"},{"location":"","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"sometype(T) gets the sometype of type T.\nsometype(x) = sometype(typeof(x)) is also provided for convenience.\n_to_sometype(T,S) converts the type S to have the sometype of T.\nsomeconvert(T,A) converts A to have the sometype of T.","category":"page"},{"location":"","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"where some can be el, base and precision.","category":"page"},{"location":"#On-precisionconvert","page":"EltypeExtensions.jl","title":"On precisionconvert","text":"","category":"section"},{"location":"","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"precisionconvert accepts an optional third argument prec. ","category":"page"},{"location":"","page":"EltypeExtensions.jl","title":"EltypeExtensions.jl","text":"When T has static precision, prec has no effect.\nWhen T has dynamic precision, prec specifies the precision of conversion. When prec is not provided, the precision is decided by the external setup from T. The difference is significant when precisionconvert is called by another function:\nprecision(BigFloat)\nf(x) = precisionconvert(BigFloat, x, precision(BigFloat))\ng(x) = precisionconvert(BigFloat, x)\nsetprecision(128)\nf(π) # static precision\ng(π) # precision varies with the global setting\nWhen T is an integer, the conversion will dig into Rational as well. In contrast, since Rational as a whole is more \"precise\" than an integer, precisiontype doesn't unwrap Rational.\nprecisiontype(precisionconvert(Int128, Int8(1)//Int8(2)))","category":"page"}]
}
