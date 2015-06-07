@reexport module DataStructures

using Reexport.@reexport

#@reexport using Graphs      # conflicts with LightGraphs
@reexport using Lazy
@reexport using LightGraphs
@reexport using NamedTuples

include("Iterators.jl")

end
