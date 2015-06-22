module Brainstorm

include("Lint.jl")

using Reexport.@reexport

VERSION < v"0.4-" && @reexport using Formatting
@reexport using Redis

include("Meta/Meta.jl")
include("DataStructure/DataStructure.jl")
include("Algorithm/Algorithm.jl")
include("Math/Math.jl")

include("../test/Brainstorm-test.jl")

end # module
