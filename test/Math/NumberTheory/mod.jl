function test_mod_multiplicativeorder()
    @test multiplicativeorder(37, 1000) == 100

    @test_throws ErrorException multiplicativeorder(3, -6)
end

function test_mod_all()
    print("Math.NumberTheory.Mod")
    print("... ")

    test_mod_multiplicativeorder()

    println("PASS")
end
