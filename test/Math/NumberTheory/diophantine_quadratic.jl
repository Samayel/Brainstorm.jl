function test_diophantine_solve_diophantine_quadratic()
    soltype = Array{AbstractDiophantineSolutions{DiophantineSolutionXY{Int64}},1}

    # linear
    sol = solve(diophantine_equation_quadratic_xy(cx=3, c0=-9))
    @test sol == [diophantine_onex_anyy(3)]
    @test typeof(sol) == soltype

    # simple hyperbolic
    sol = solve(diophantine_equation_quadratic_xy(cxy=4, cx=2, cy=8, c0=4))
    @test sol == [diophantine_onex_anyy(-2)]
    @test typeof(sol) == soltype

    sol = solve(diophantine_equation_quadratic_xy(cxy=4, cx=12, cy=8, c0=24))
    @test sol == [diophantine_onex_anyy(-2), diophantine_anyx_oney(-3)]
    @test typeof(sol) == soltype

    sol = solve(diophantine_equation_quadratic_xy(cxy=2, cx=5, cy=56, c0=7))
    @test sol == [diophantine_solutions((-27,64), (-29,-69), (-21,7), (-35,-12), (-9,1), (-47,-6), (105,-2), (-161,-3))]
    @test typeof(sol) == soltype
end
