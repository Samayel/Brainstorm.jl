function test_arctan_all()
    print(rpad("Math.Series.arctan[h]...", 50, ' '))

    arctan = Brainstorm.Math.Series.Arctan.arctan
    arctanh = Brainstorm.Math.Series.Arctan.arctanh

    with_bigfloat_precision(400000) do
        @test all([arctan(d, x)  - trunc(BigInt, atan(1//big(x))*(big(10)^d))  for x in (2,3,5,17), d in (1, 10, 100, 1000, 10000, 100000)] .== 0)
        @test all([arctanh(d, x) - trunc(BigInt, atanh(1//big(x))*(big(10)^d)) for x in (2,3,5,17), d in (1, 10, 100, 1000, 10000, 100000)] .== 0)
    end

    println("PASS")
end
