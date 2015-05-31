@reexport module NumberTheory

using Brainstorm.DataStructures: takewhile
using Brainstorm.Math: checked_add, checked_sub
using DataStructures: SortedDict
using Iterators: drop, imap, take

if VERSION < v"0.4-"
  include("Combinatorics.jl")
end

include("Primes.jl")
include("Fibonacci.jl")

end
