function test_diophantine_solve_diophantine_linear()
    @test solve(diophantine_equation_linear_xy()) == diophantine_anyx_anyy()
    @test solve(diophantine_equation_linear_xy(c0=1)) == diophantine_nonex_noney()

    @test solve(diophantine_equation_linear_xy(cy=2, c0=10)) == diophantine_anyx_oney(-5)
    @test solve(diophantine_equation_linear_xy(cy=2, c0=11)) == diophantine_nonex_noney()

    @test solve(diophantine_equation_linear_xy(cx=3, c0=-9)) == diophantine_onex_anyy(3)
    @test solve(diophantine_equation_linear_xy(cx=3, c0=2)) == diophantine_nonex_noney()

    eq = diophantine_equation_linear_xy(cx=10, cy=84, c0=16)
    sol = take(solve(eq), 1000) |> collect
    @test Int[evaluate(eq, s) for s in sol] == zeros(Int, 1000)

    @test solve(diophantine_equation_linear_xy(cx=10, cy=84, c0=-15)) == diophantine_nonex_noney()
end
