function test_genfunc_expand_maclaurin_series()
    @test expand_maclaurin_series(z -> 1/(1-z), 10) == Taylor1([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
    @test expand_maclaurin_series(z -> 1/(1-z^2), 10) == Taylor1([1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1])
    @test expand_maclaurin_series(z -> 1/(1-z)^2, 10) == Taylor1([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
    @test expand_maclaurin_series(z -> z/(1-z)^2, 10) == Taylor1([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    @test expand_maclaurin_series(z -> (1+z)/(1-z)^3, 10) == Taylor1([1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121])

    # rounding errors: @test expand_maclaurin_series(z -> exp(z), 4, Rational) == Taylor1([1, 1, 1//2, 1//6, 1//24])
    # rounding errors: @test expand_maclaurin_series(z -> sin(z), 7, Rational) == Taylor1([0, 1, 0, -1//6, 0, 1//120, 0, -1//5040])
end

function test_genfunc_coefficient()
    @test coefficient(Taylor1([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]), 10) == 1
    @test coefficient(Taylor1([1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]), 10) == 1
    @test coefficient(Taylor1([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]), 10) == 11
    @test coefficient(Taylor1([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), 10) == 10
    @test coefficient(Taylor1([1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121]), 10) == 121

    @test coefficient(Taylor1([1, 1, 1//2, 1//6, 1//24]), 4) == 1//24
    @test coefficient(Taylor1([0, 1, 0, -1//6, 0, 1//120, 0, -1//5040]), 7) == -1//5040
end

function test_genfunc_coefficients()
    @test coefficients(Taylor1([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])) == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    @test coefficients(Taylor1([1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1])) == [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
    @test coefficients(Taylor1([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    @test coefficients(Taylor1([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])) == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @test coefficients(Taylor1([1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121])) == [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121]

    @test coefficients(Taylor1([1, 1, 1//2, 1//6, 1//24])) == [1, 1, 1//2, 1//6, 1//24]
    @test coefficients(Taylor1([0, 1, 0, -1//6, 0, 1//120, 0, -1//5040])) == [0, 1, 0, -1//6, 0, 1//120, 0, -1//5040]
end

function test_genfunc_all()
    print(rpad("Math.NumberTheory.GenFunc...", 50, ' '))

    test_genfunc_expand_maclaurin_series()
    test_genfunc_coefficient()
    test_genfunc_coefficients()

    println("PASS")
end
