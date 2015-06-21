module Brainstorm

include("Lint.jl")

using Reexport.@reexport

VERSION < v"0.4-" && @reexport using Formatting
@reexport using Redis

include("Meta/Meta.jl")
include("DataStructures/DataStructures.jl")
include("Algorithms/Algorithms.jl")
include("Math/Math.jl")

include("../test/Brainstorm-test.jl")

end # module
