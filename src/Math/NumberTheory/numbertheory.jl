@reexport module NumberTheory

using Brainstorm: takewhile
using Brainstorm.Math: checked_add, checked_sub
using DataStructures: SortedDict
using Iterators: drop, imap, take
using Pipe.@pipe
using Reexport.@reexport

VERSION < v"0.4-" && @reexport using Combinatorics
@reexport using ContinuedFractions
@reexport using Digits

include("primes.jl")
include("factor.jl")
include("mod.jl")
include("decimal.jl")
include("fibonacci.jl")
include("hailstone.jl")

end
