function test_ln2_all()
    print(rpad("Math.Series.ln(2)...", 50, ' '))

    ln2 = Brainstorm.Math.Series.Ln2.Machin.ln2

    with_bigfloat_precision(4_000_000) do
        @test all([ln2(d) - trunc(BigInt, log(big(2))*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] .== 0)
    end

    println("PASS")
end
