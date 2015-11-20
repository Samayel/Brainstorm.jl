function test_pi_all()
    print(rpad("Math.Series.Pi...", 50, ' '))

    simple = Brainstorm.Math.Series.Pi.Chudnovsky.Simple.pi
    inplace = Brainstorm.Math.Series.Pi.Chudnovsky.Inplace.pi

    with_bigfloat_precision(4000000) do
        @test all([simple(d)  - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1000, 10000, 100000, 1000000)] .== 0)
        @test all([inplace(d) - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1000, 10000, 100000, 1000000)] .== 0)
    end

    println("PASS")
end
