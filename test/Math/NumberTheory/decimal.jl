function test_decimal_decimalperiod()
    @test [decimalperiod(1, i) for i = 1:10] == [0, 0, 1, 0, 0, 1, 6, 0, 1, 0]
end

function test_decimal_all()
    print(rpad("Math.NumberTheory.Decimal...", 50, ' '))

    test_decimal_decimalperiod()

    println("PASS")
end
