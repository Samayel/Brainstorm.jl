module _NumberTheory

using Brainstorm._Math._NumberTheory
using Base.Test
using Primes: primes

include("primes.jl")
include("Primes/native.jl")
include("factor.jl")
include("mod.jl")
include("decimal.jl")
include("fibonacci.jl")
include("hailstone.jl")
include("triangle.jl")
include("pentagon.jl")
include("hexagon.jl")
include("confrac.jl")
include("diophantine.jl")

function test_all()
    test_primes_all()
    _Primes.test_all()
    test_factor_all()
    test_mod_all()
    test_decimal_all()
    test_fibonacci_all()
    test_hailstone_all()
    test_triangle_all()
    test_pentagon_all()
    test_hexagon_all()
    test_confrac_all()
    test_diophantine_all()
end

end
