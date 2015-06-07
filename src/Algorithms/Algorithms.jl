@reexport module Algorithms

using Reexport.@reexport

VERSION < v"0.4-" && @reexport using IterationManagers
@reexport using SortingAlgorithms

end
