function test_euler_all()
    print(rpad("Math.Constants.e...", 50, ' '))

    simple = Brainstorm.Math.Constants.Euler.Taylor.Simple.euler
    inplace = Brainstorm.Math.Constants.Euler.Taylor.Inplace.euler

    with_bigfloat_precision(4000000) do
        @test all([simple(d)  - trunc(BigInt, e*(big(10)^d)) for d in (1, 10, 100, 1000, 10000, 100000, 1000000)] .== 0)
        @test all([inplace(d) - trunc(BigInt, e*(big(10)^d)) for d in (1, 10, 100, 1000, 10000, 100000, 1000000)] .== 0)
    end

    println("PASS")
end
