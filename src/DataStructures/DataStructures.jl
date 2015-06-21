@reexport module DataStructures

using Reexport.@reexport

@reexport using AutoHashEquals
@reexport using BloomFilters
@reexport using DataStructures
@reexport using DeepConvert
@reexport using FunctionalCollections
#@reexport using Graphs                         # conflicts with LightGraphs
@reexport using ImmutableArrays
@reexport using IndexedArrays
@reexport using Iterators
VERSION < v"0.4-" && @reexport using Lazy
@reexport using LightGraphs
VERSION < v"0.4-" && @reexport using NamedArrays
@reexport using NamedTuples
@reexport using ShowSet
@reexport using SparseVectors

include("Iterators.jl")

end
