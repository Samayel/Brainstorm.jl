module Math

using Brainstorm.Math
using Base.Test

function test_math_setbits()
    @test setbits(0, []) == 0
    @test setbits(0, [0]) == 2^0
    @test setbits(0, [1]) == 2^1
    @test setbits(0, [10]) == 2^10
    @test setbits(0, [1,3]) == 2^1 + 2^3

    @test setbits(12, []) == 12
    @test setbits(12, [2,3]) == 12
    @test setbits(12, [0,1,2,3]) == 15

    @test setbits(big(0), []) == big(0)
    @test setbits(big(0), [1000]) == big(2)^1000
end

include("EllipticCurves/ellipticcurves.jl")
include("Series/series.jl")
include("NumberTheory/numbertheory.jl")
include("Combinatorics/combinatorics.jl")

function test_all()
    println("")
    print(rpad("Math...", 50, ' '))

    test_math_setbits()

    println("PASS")

    println("")
    Series.test_all()
    println("")
    NumberTheory.test_all()
    println("")
    Combinatorics.test_all()
    println("")
    EllipticCurves.test_all()
end

end
