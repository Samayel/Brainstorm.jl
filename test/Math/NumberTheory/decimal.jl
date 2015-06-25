function test_decimal_decimalperiod()
    @test [decimalperiod(1, i) for i = 1:10] == [0, 0, 1, 0, 0, 1, 6, 0, 1, 0]
end

function test_decimal_all()
    print("Math.NumberTheory.Decimal")
    print("... ")

    test_decimal_decimalperiod()

    println("PASS")
end
