function test_ln2_all()
    print(rpad("Math.Series.ln(2)...", 50, ' '))

    ln2_N2a = Brainstorm.Math.Series.Ln2.Machin.ln2_N2a
    ln2_N2b = Brainstorm.Math.Series.Ln2.Machin.ln2_N2b
    ln2_N2c = Brainstorm.Math.Series.Ln2.Machin.ln2_N2c

    ln2_N3a = Brainstorm.Math.Series.Ln2.Machin.ln2_N3a
    ln2_N3b = Brainstorm.Math.Series.Ln2.Machin.ln2_N3b
    ln2_N3c = Brainstorm.Math.Series.Ln2.Machin.ln2_N3c
    ln2_N3d = Brainstorm.Math.Series.Ln2.Machin.ln2_N3d
    ln2_N3e = Brainstorm.Math.Series.Ln2.Machin.ln2_N3e

    ln2_N4a = Brainstorm.Math.Series.Ln2.Machin.ln2_N4a
    ln2_N4b = Brainstorm.Math.Series.Ln2.Machin.ln2_N4b
    ln2_N4c = Brainstorm.Math.Series.Ln2.Machin.ln2_N4c

    ln2_N5a = Brainstorm.Math.Series.Ln2.Machin.ln2_N5a

    with_bigfloat_precision(400_000) do
        expected = [trunc(BigInt, log(big(2))*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000)]

        @test all([ln2_N2a(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)
        @test all([ln2_N2b(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)
        @test all([ln2_N2c(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)

        @test all([ln2_N3a(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)
        @test all([ln2_N3b(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)
        @test all([ln2_N3c(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)
        @test all([ln2_N3d(d) for d in (1, 10, 100, 1_000, 10_000, 100_000)] - expected      .== 0)
        @test all([ln2_N3e(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)

        @test all([ln2_N4a(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)
        @test all([ln2_N4b(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)
        @test all([ln2_N4c(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)

        @test all([ln2_N5a(d) for d in (1, 10, 100, 1_000, 10_000)]          - expected[1:5] .== 0)
    end

    println("PASS")
end
