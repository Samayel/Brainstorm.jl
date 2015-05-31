module NumberTheory

using Brainstorm.Math

if VERSION < v"0.4-"
  include("Combinatorics.jl")
end

include("Primes.jl")
include("Fibonacci.jl")

include("Export.jl")

end
