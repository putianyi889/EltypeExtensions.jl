module EltypeExtensionsQuasiArraysExt

import QuasiArrays: AbstractQuasiArray
import EltypeExtensions: elconvert

elconvert(::Type{T}, A::AbstractQuasiArray) where T = AbstractQuasiArray{T}(A)

end # module