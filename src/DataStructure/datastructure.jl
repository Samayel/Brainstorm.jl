@reexport module DataStructure

using Reexport.@reexport

@reexport using AutoHashEquals
@reexport using BloomFilters
@reexport using DataStructures
VERSION < v"0.4-" && @reexport using Dates
VERSION >= v"0.4-" && @reexport using Base.Dates
@reexport using DeepConvert
@reexport using FunctionalCollections
#@reexport using Graphs                         # conflicts with LightGraphs
@reexport using ImmutableArrays
@reexport using IndexedArrays
@reexport using Iterators
#VERSION < v"0.4-" && @reexport using Lazy      # conflicts with Iterators.drop
@reexport using LightGraphs
VERSION < v"0.4-" && @reexport using NamedArrays
@reexport using NamedTuples
@reexport using ShowSet
@reexport using SparseVectors

export
    flatten

# https://groups.google.com/d/msg/julia-users/1QrIhbRA8hs/9PcNeO2N9wQJ
flatten{T}(a::Array{T,1}) =
    any(map(x -> isa(x, Array), a)) ? flatten(vcat(map(flatten, a)...)) : a
flatten{T}(a::Array{T}) = reshape(a, prod(size(a)))
flatten(a) = a

include("iterator.jl")
include("vector.jl")
include("matrix.jl")

end
