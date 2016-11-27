function test_sqrt_all()
    print(rpad("Math.Series.[1/]sqrt(x)...", 50, ' '))

    sqrt = Brainstorm.Math.Series.Sqrt.sqrt
    rsqrt = Brainstorm.Math.Series.Sqrt.rsqrt

    setprecision(4_000_000) do
        @test all([sqrt(d, x)  - trunc(BigInt, Base.sqrt(  big(x))*(big(10)^d)) for x in (2, 3, 5, 17, 1_000_003, 1_000_033, 1_000_037), d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] .== 0)
        @test all([rsqrt(d, x) - trunc(BigInt, Base.sqrt(1/big(x))*(big(10)^d)) for x in (2, 3, 5, 17, 1_000_003, 1_000_033, 1_000_037), d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] .== 0)
    end

    println("PASS")
end
