module NumberTheory

using Brainstorm.Math.NumberTheory
using Base.Test
using Compat

include("Primes-test.jl")
include("Fibonacci-test.jl")

function test_all()
    test_primes_all()
    test_fibonacci_all()
end

end
