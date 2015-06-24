module NumberTheory

using Brainstorm.Math.NumberTheory
using Base.Test
using Compat

include("Primes-test.jl")
include("Primes-native-test.jl")
include("Divisors-test.jl")
include("Fibonacci-test.jl")
include("Hailstone-test.jl")

function test_all()
    test_primes_all()
    PrimesNative.test_primesnative_all()
    test_divisors_all()
    test_fibonacci_all()
    test_hailstone_all()
end

end
