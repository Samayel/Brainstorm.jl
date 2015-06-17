@reexport module DataStructures

using Reexport.@reexport

@reexport using AutoHashEquals
@reexport using DataStructures
@reexport using FunctionalCollections
#@reexport using Graphs                         # conflicts with LightGraphs
@reexport using Iterators
VERSION < v"0.4-" && @reexport using Lazy
@reexport using LightGraphs
@reexport using NamedTuples
@reexport using SparseVectors

include("Iterators.jl")

end
