function test_decimal_decimalperiod()
    @test [decimalperiod(1, i) for i = 1:10] == [0, 0, 1, 0, 0, 1, 6, 0, 1, 0]
end

function test_decimal_ispandigital()
    @test ispandigital(0) == false
    @test ispandigital(1) == true
    @test ispandigital(2) == false
    @test ispandigital(10) == false
    @test ispandigital(11) == false
    @test ispandigital(12) == true
    @test ispandigital(123) == true
    @test ispandigital(124) == false
    @test ispandigital(123456789) == true
    @test ispandigital(1234567890) == false
end

function test_decimal_all()
    print(rpad("Math.NumberTheory.Decimal...", 50, ' '))

    test_decimal_decimalperiod()
    test_decimal_ispandigital()

    println("PASS")
end
