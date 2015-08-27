function test_diophantine_solve_diophantine_quadratic()
    soltype = Array{AbstractDiophantineSolutions{DiophantineSolutionXY{Int64}},1}

    # linear
    sol = solve(DiophantineEquationQuadraticXY(0, 0, 0, 3, 0, -9))
    @test sol == [diophantine_onex_anyy(3)]
    @test typeof(sol) == soltype

    # simple hyperbolic
    sol = solve(DiophantineEquationQuadraticXY(0, 4, 0, 2, 8, 4))
    @test sol == [diophantine_onex_anyy(-2)]
    @test typeof(sol) == soltype

    sol = solve(DiophantineEquationQuadraticXY(0, 4, 0, 12, 8, 24))
    @test sol == [diophantine_onex_anyy(-2), diophantine_anyx_oney(-3)]
    @test typeof(sol) == soltype

    sol = solve(DiophantineEquationQuadraticXY(0, 2, 0, 5, 56, 7))
    @test sol == [diophantine_solutions((-27,64), (-29,-69), (-21,7), (-35,-12), (-9,1), (-47,-6), (105,-2), (-161,-3))]
    @test typeof(sol) == soltype
end
