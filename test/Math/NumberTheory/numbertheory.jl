module NumberTheory

using Brainstorm.Math.NumberTheory
using Base.Test
using Compat
using TaylorSeries: Taylor1

include("primes.jl")
include("Primes/native.jl")
include("factor.jl")
include("mod.jl")
include("decimal.jl")
include("fibonacci.jl")
include("hailstone.jl")
include("triangle.jl")
include("genfunc.jl")

function test_all()
    test_primes_all()
    Primes.test_all()
    test_factor_all()
    test_mod_all()
    test_decimal_all()
    test_fibonacci_all()
    test_hailstone_all()
    test_triangle_all()
    test_genfunc_all()
end

end
