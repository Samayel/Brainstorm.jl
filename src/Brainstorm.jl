__precompile__(false)

module Brainstorm

using Reexport: @reexport

include("lint.jl")

include("Meta/meta.jl")
include("DataStructure/datastructure.jl")
include("Algorithm/algorithm.jl")
include("Math/math.jl")

include("../test/test.jl")

end # module
