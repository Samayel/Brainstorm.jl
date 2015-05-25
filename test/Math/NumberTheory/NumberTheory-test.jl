module NumberTheory

using Brainstorm
using Base.Test

include("Fibonacci-test.jl")
include("Primes-test.jl")

function test_all()
  test_fibonacci_all()
  test_primes_all()
  println("")
end

end
