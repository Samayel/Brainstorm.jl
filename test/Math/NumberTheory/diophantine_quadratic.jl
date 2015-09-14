function test_diophantine_solve_diophantine_quadratic()
    soltype = Array{AbstractDiophantineSolutions{DiophantineSolutionXY{Int}},1}

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
    @test sol == [diophantine_solutions((-27, 64), (-29, -69), (-21, 7), (-35, -12), (-9, 1), (-47, -6), (105, -2), (-161, -3))]
    @test typeof(sol) == soltype

    # elliptical
    sol = solve(diophantine_equation_quadratic_xy(cx²=42, cxy=8, cy²=15, cx=23, cy=17, c0=-4915))
    @test sol == [diophantine_solutions((-11, -1))]
    @test typeof(sol) == soltype

    # parabolic
    sol = solve(diophantine_equation_quadratic_xy(cx²=1, cxy=2, cy²=1, cx=2, cy=2, c0=1))
    @test sol == [diophantine_linearx_lineary(1, 0, -1, -1)]
    @test typeof(sol) == soltype

    sol = solve(diophantine_equation_quadratic_xy(cx²=1, cxy=2, cy²=1, cx=6, cy=6, c0=5))
    @test sol == [diophantine_linearx_lineary(1, 0, -1, -1), diophantine_linearx_lineary(1, 0, -1, -5)]
    @test typeof(sol) == soltype

    sol = solve(diophantine_equation_quadratic_xy(cx²=8, cxy=-24, cy²=18, cx=5, cy=7, c0=16))
    @test sol == [diophantine_quadraticx_quadraticy(-174, 17, -2, -116, 21, -2), diophantine_quadraticx_quadraticy(-174, 41, -4, -116, 37, -4)]
    @test typeof(sol) == soltype

    # hyperbolic (WIP)
    sol = solve(diophantine_equation_quadratic_xy(cx²=1, cxy=3, cy²=2))
    @test sol == [diophantine_solutions((0, 0)), diophantine_linearx_lineary(2, 0, -1, 0), diophantine_linearx_lineary(1, 0, -1, 0)]
    @test typeof(sol) == soltype

    sol = solve(diophantine_equation_quadratic_xy(cx²=1, cxy=3, cy²=2, c0=10))
    @test sol == [diophantine_solutions((-21, 11), (21, -11), (-12, 7), (12, -7), (-9, 7), (9, -7), (-12, 11), (12, -11))]
    @test typeof(sol) == soltype
end
