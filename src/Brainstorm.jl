module Brainstorm

include("lint.jl")

using Reexport.@reexport

VERSION < v"0.4-" && @reexport using Formatting
@reexport using Redis

include("Meta/meta.jl")
include("DataStructure/datastructure.jl")
include("Algorithm/algorithm.jl")
include("Math/math.jl")

include("../test/Brainstorm.jl")

end # module
