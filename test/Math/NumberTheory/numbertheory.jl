module NumberTheory

using Brainstorm.Math.NumberTheory
using Base.Test
using Compat

include("primes.jl")
include("Primes/native.jl")
include("divisor.jl")
include("fibonacci.jl")
include("hailstone.jl")

function test_all()
    test_primes_all()
    Primes.test_all()
    test_divisor_all()
    test_fibonacci_all()
    test_hailstone_all()
end

end
