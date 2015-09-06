__precompile__(false)

module Brainstorm

include("lint.jl")

using Reexport.@reexport

@reexport using Formatting
@reexport using Redis

include("Meta/meta.jl")
include("DataStructure/datastructure.jl")
include("Algorithm/algorithm.jl")
include("Math/math.jl")

include("../test/test.jl")

end # module
