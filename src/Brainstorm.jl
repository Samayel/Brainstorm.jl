module Brainstorm

using Reexport.@reexport

include("Meta/Meta.jl")
include("DataStructures/DataStructures.jl")
include("Algorithms/Algorithms.jl")
include("Math/Math.jl")

include("../test/Brainstorm-test.jl")

end # module
