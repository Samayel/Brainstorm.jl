@reexport module NumberTheory

using Brainstorm.DataStructures: takewhile
using Brainstorm.Math: checked_add, checked_sub
using DataStructures: SortedDict
using Iterators: drop, imap, take
using Pipe.@pipe
using Reexport.@reexport

if VERSION < v"0.4-"
  @reexport using Combinatorics
end

include("Primes.jl")
include("Fibonacci.jl")

end
