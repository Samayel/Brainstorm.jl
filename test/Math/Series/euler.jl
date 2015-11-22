function test_euler_all()
    print(rpad("Math.Series.e...", 50, ' '))

    simple = Brainstorm.Math.Series.Euler.Taylor.Simple.euler
    inplace = Brainstorm.Math.Series.Euler.Taylor.Inplace.euler

    with_bigfloat_precision(4_000_000) do
        @test all([simple(d)  - trunc(BigInt, e*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] .== 0)
        @test all([inplace(d) - trunc(BigInt, e*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] .== 0)
    end

    println("PASS")
end
