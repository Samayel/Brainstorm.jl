@reexport module _GroupTheory

import Base: circshift!, getindex
import Nemo

using Nemo: PermutationGroup, perm

include("permutation.jl")

end
