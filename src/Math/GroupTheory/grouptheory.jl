@reexport module _GroupTheory

import Base: *, ^, circshift!, getindex, inv, one

using AutoHashEquals: @auto_hash_equals

include("permutation.jl")

end
