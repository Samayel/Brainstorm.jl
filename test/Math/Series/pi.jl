function test_pi_chudnovsky()
    simple  = Brainstorm._Math._Series._Pi._Chudnovsky._Simple.pi
    inplace = Brainstorm._Math._Series._Pi._Chudnovsky._Inplace.pi

    setprecision(4_000_000) do
        expected = [trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)]

        @test all([simple(d)  for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] - expected .== 0)
        @test all([inplace(d) for d in (1, 10, 100, 1_000, 10_000, 100_000, 1_000_000)] - expected .== 0)
    end
end

function test_pi_machin()
    euler           = Brainstorm._Math._Series._Pi._Machin.euler
    hermann         = Brainstorm._Math._Series._Pi._Machin.hermann
    hutton          = Brainstorm._Math._Series._Pi._Machin.hutton
    machin          = Brainstorm._Math._Series._Pi._Machin.machin

    gauss           = Brainstorm._Math._Series._Pi._Machin.gauss
    strassnitzky    = Brainstorm._Math._Series._Pi._Machin.strassnitzky
    klingenstierna  = Brainstorm._Math._Series._Pi._Machin.klingenstierna
    euler3          = Brainstorm._Math._Series._Pi._Machin.euler3
    loney           = Brainstorm._Math._Series._Pi._Machin.loney
    stoermer        = Brainstorm._Math._Series._Pi._Machin.stoermer

    takano1982      = Brainstorm._Math._Series._Pi._Machin.takano1982
    stoermer1896    = Brainstorm._Math._Series._Pi._Machin.stoermer1896

    hwang1997       = Brainstorm._Math._Series._Pi._Machin.hwang1997
    hwang2003       = Brainstorm._Math._Series._Pi._Machin.hwang2003
    wetherfield2004 = Brainstorm._Math._Series._Pi._Machin.wetherfield2004

    setprecision(40_000) do
        expected = [trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)]

        @test all([euler(d)           for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([hermann(d)         for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([hutton(d)          for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([machin(d)          for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)

        @test all([gauss(d)           for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([strassnitzky(d)    for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([klingenstierna(d)  for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([euler3(d)          for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([loney(d)           for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([stoermer(d)        for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)

        @test all([takano1982(d)      for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([stoermer1896(d)    for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)

        @test all([hwang1997(d)       for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([hwang2003(d)       for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
        @test all([wetherfield2004(d) for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
    end
end

function test_pi_gausslegendre()
    int_simple    = Brainstorm._Math._Series._Pi._Iterative._GaussLegendre._Int._Simple.pi
    int_inplace   = Brainstorm._Math._Series._Pi._Iterative._GaussLegendre._Int._Inplace.pi
    float_simple  = Brainstorm._Math._Series._Pi._Iterative._GaussLegendre._Float._Simple.pi
    float_inplace = Brainstorm._Math._Series._Pi._Iterative._GaussLegendre._Float._Inplace.pi

    setprecision(400_000) do
        expected = [trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000)]

        @test all([int_simple(d)                               for d in (1, 10, 100, 1_000, 10_000, 100_000)] - expected .== 0)
        @test all([int_inplace(d)                              for d in (1, 10, 100, 1_000, 10_000, 100_000)] - expected .== 0)
        @test all([trunc(BigInt, float_simple(d)*(big(10)^d))  for d in (1, 10, 100, 1_000, 10_000, 100_000)] - expected .== 0)
        @test all([trunc(BigInt, float_inplace(d)*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000, 100_000)] - expected .== 0)
    end
end

function test_pi_sine()
    sine = Brainstorm._Math._Series._Pi._Iterative._Sine.pi

    setprecision(40_000) do
        expected = [trunc(BigInt, pi*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)]

        @test all([trunc(BigInt, sine(d)*(big(10)^d)) for d in (1, 10, 100, 1_000, 10_000)] - expected .== 0)
    end
end

function test_pi_all()
    print(rpad("Math.Series.Pi...", 50, ' '))

    test_pi_chudnovsky()
    test_pi_machin()
    test_pi_gausslegendre()
    test_pi_sine()

    println("PASS")
end
