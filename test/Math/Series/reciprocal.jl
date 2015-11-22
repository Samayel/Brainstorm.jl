function test_reciprocal_all()
    print(rpad("Math.Series.1/x...", 50, ' '))

    reciprocal = Brainstorm.Math.Series.Reciprocal.reciprocal

    with_bigfloat_precision(4_000_000) do
        @test all([reciprocal(d, x) - trunc(BigInt, (1/big(x))*(big(10)^d)) for x in (1_000_003, 1_000_033, 1_000_037), d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] .== 0)
    end

    println("PASS")
end
