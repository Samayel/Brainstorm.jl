function test_sqrt_all()
    print(rpad("Math.Series.sqrt(x)...", 50, ' '))

    sqrt = Brainstorm.Math.Series.Sqrt.sqrt
    rsqrt = Brainstorm.Math.Series.Sqrt.rsqrt

    with_bigfloat_precision(400000) do
        @test all([sqrt(d, x)  - trunc(BigInt, Base.sqrt(  big(x))*(big(10)^d)) for x in (2,3,5,17), d in (1, 10, 100, 1000, 10000, 100000)] .== 0)
        @test all([rsqrt(d, x) - trunc(BigInt, Base.sqrt(1/big(x))*(big(10)^d)) for x in (2,3,5,17), d in (1, 10, 100, 1000, 10000, 100000)] .== 0)
    end

    println("PASS")
end
