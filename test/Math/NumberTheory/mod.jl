function test_mod_multiplicativeorder()
    @test multiplicativeorder(1, 11) == 1
    @test multiplicativeorder(2, 7) == 3
    @test multiplicativeorder(3, 7) == 6
    @test multiplicativeorder(7, 5) == 4
    @test multiplicativeorder(37, 1000) == 100

    @test_throws ErrorException multiplicativeorder(3, -6)
end

function test_mod_linearmod()
    @test linearmod(3, 5, 6) == []
    @test linearmod(3, 4, 5) == [3]
    @test linearmod(3, 6, 9) == [2, 5, 8]
    @test linearmod(-14, 30, 100) == [5, 55]

    @test_throws ErrorException linearmod(3, 4, 1)
end

function test_mod_primitiveroot()
    @test primitiveroot(2) == 1
    @test primitiveroot(17) == 3
    @test primitiveroot(71) == 7
    @test primitiveroot(101) == 2

    @test_throws ErrorException primitiveroot(4)
end

function test_mod_all()
    print(rpad("Math.NumberTheory.Mod...", 50, ' '))

    test_mod_multiplicativeorder()
    test_mod_linearmod()
    test_mod_primitiveroot()

    println("PASS")
end
