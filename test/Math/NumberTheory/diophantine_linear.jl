function test_diophantine_solve_diophantine_linear()
    @test solve(DiophantineEquationLinearXY(0, 0, 0)) == diophantine_anyx_anyy()
    @test solve(DiophantineEquationLinearXY(0, 0, 1)) == diophantine_nonex_noney()

    @test solve(DiophantineEquationLinearXY(0, 2, 10)) == diophantine_anyx_oney(-5)
    @test solve(DiophantineEquationLinearXY(0, 2, 11)) == diophantine_nonex_noney()

    @test solve(DiophantineEquationLinearXY(3, 0, -9)) == diophantine_onex_anyy(3)
    @test solve(DiophantineEquationLinearXY(3, 0, 2)) == diophantine_nonex_noney()

    sol = collect(take(solve(DiophantineEquationLinearXY(10, 84, 16)), 1000))
    @test [10*s.x+84*s.y+16 for s in sol] == zeros(1000)
    @test solve(DiophantineEquationLinearXY(10, 84, -15)) == diophantine_nonex_noney()
end
