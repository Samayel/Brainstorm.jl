function test_pi_chudnovsky()
    simple  = Brainstorm.Math.Series.Pi.Chudnovsky.Simple.pi
    inplace = Brainstorm.Math.Series.Pi.Chudnovsky.Inplace.pi

    with_bigfloat_precision(4_000_000) do
        expected = [trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)]

        @test all([simple(d)  for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] - expected .== 0)
        @test all([inplace(d) for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] - expected .== 0)
    end
end

function test_pi_machin()
    euler   = Brainstorm.Math.Series.Pi.Machin.euler
    hermann = Brainstorm.Math.Series.Pi.Machin.hermann
    hutton  = Brainstorm.Math.Series.Pi.Machin.hutton
    machin  = Brainstorm.Math.Series.Pi.Machin.machin

    gauss        = Brainstorm.Math.Series.Pi.Machin.gauss
    strassnitzky = Brainstorm.Math.Series.Pi.Machin.strassnitzky

    takano1982   = Brainstorm.Math.Series.Pi.Machin.takano1982
    stoermer1896 = Brainstorm.Math.Series.Pi.Machin.stoermer1896

    hwang1997       = Brainstorm.Math.Series.Pi.Machin.hwang1997
    hwang2003       = Brainstorm.Math.Series.Pi.Machin.hwang2003
    wetherfield2004 = Brainstorm.Math.Series.Pi.Machin.wetherfield2004

    with_bigfloat_precision(40_000) do
        expected = [trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)]

        @test all([euler(d)           for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([hermann(d)         for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([hutton(d)          for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([machin(d)          for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)

        @test all([gauss(d)           for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([strassnitzky(d)    for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)

        @test all([takano1982(d)      for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([stoermer1896(d)    for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)

        @test all([hwang1997(d)       for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([hwang2003(d)       for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([wetherfield2004(d) for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
    end
end

function test_pi_agm()
    int_simple   = Brainstorm.Math.Series.Pi.Iterative.AGM.Int.Simple.pi
    int_inplace  = Brainstorm.Math.Series.Pi.Iterative.AGM.Int.Inplace.pi
    float_simple = Brainstorm.Math.Series.Pi.Iterative.AGM.Float.Simple.pi

    with_bigfloat_precision(400_000) do
        expected = [trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000)]

        @test all([int_simple(d)                              for d in (1, 10, 100, 1_000, 10_000, 100_000)] - expected .== 0)
        @test all([int_inplace(d)                             for d in (1, 10, 100, 1_000, 10_000, 100_000)] - expected .== 0)
        @test all([trunc(BigInt, float_simple(d)*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000)] - expected .== 0)
    end
end

function test_pi_all()
    print(rpad("Math.Series.Pi...", 50, ' '))

    test_pi_chudnovsky()
    test_pi_machin()
    test_pi_agm()

    println("PASS")
end
