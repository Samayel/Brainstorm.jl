@reexport module DataStructures

using Reexport.@reexport

@reexport using DataStructures
#@reexport using Graphs      # conflicts with LightGraphs
@reexport using Iterators
@reexport using Lazy
@reexport using LightGraphs
@reexport using NamedTuples

include("Iterators.jl")

end
