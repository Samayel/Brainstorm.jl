function test_pi_chudnovsky()
    simple  = Brainstorm.Math.Series.Pi.Chudnovsky.Simple.pi
    inplace = Brainstorm.Math.Series.Pi.Chudnovsky.Inplace.pi

    with_bigfloat_precision(4_000_000) do
        @test all([simple(d)  - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] .== 0)
        @test all([inplace(d) - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] .== 0)
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
        @test all([euler(d)           - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)
        @test all([hermann(d)         - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)
        @test all([hutton(d)          - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)
        @test all([machin(d)          - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)

        @test all([gauss(d)           - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)
        @test all([strassnitzky(d)    - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)

        @test all([takano1982(d)      - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)
        @test all([stoermer1896(d)    - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)

        @test all([hwang1997(d)       - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)
        @test all([hwang2003(d)       - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)
        @test all([wetherfield2004(d) - trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] .== 0)
    end
end

function test_pi_all()
    print(rpad("Math.Series.Pi...", 50, ' '))

    test_pi_chudnovsky()
    test_pi_machin()

    println("PASS")
end
