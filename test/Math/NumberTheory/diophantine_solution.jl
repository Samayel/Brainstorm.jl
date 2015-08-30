
function test_diophantine_solutions()
    a = diophantine_solution(1, 2)
    b = diophantine_solution(7, 9)
    c = diophantine_solution(-2, 42)
    s = [a, b, c]

    @test collect(diophantine_solutions(s)) == s
    @test eltype(diophantine_solutions(s)) == DiophantineSolutionXY{Int}

    x = diophantine_solution(big(0), big(0))
    @test eltype(diophantine_solutions([x])) == DiophantineSolutionXY{BigInt}
end

function test_diophantine_solutions_nonex_noney()
    @test collect(diophantine_nonex_noney()) == []
    @test eltype(diophantine_nonex_noney()) == DiophantineSolutionXY{Int}
    @test eltype(diophantine_nonex_noney(BigInt)) == DiophantineSolutionXY{BigInt}
end

function test_diophantine_solutions_anyx_anyy()
end

function test_diophantine_solutions_onex_anyy()
    @test collect(take(diophantine_onex_anyy(42), 5)) == [
        diophantine_solution(42, 0),
        diophantine_solution(42, 1),
        diophantine_solution(42, -1),
        diophantine_solution(42, 2),
        diophantine_solution(42, -2)
    ]
    @test eltype(diophantine_onex_anyy(42)) == DiophantineSolutionXY{Int}

    @test collect(take(diophantine_onex_anyy(big(42)), 5)) == [
        diophantine_solution(big(42), big(0)),
        diophantine_solution(big(42), big(1)),
        diophantine_solution(big(42), big(-1)),
        diophantine_solution(big(42), big(2)),
        diophantine_solution(big(42), big(-2))
    ]
    @test eltype(diophantine_onex_anyy(big(42))) == DiophantineSolutionXY{BigInt}
end

function test_diophantine_solutions_anyx_oney()
    @test collect(take(diophantine_anyx_oney(42), 5)) == [
        diophantine_solution(0, 42),
        diophantine_solution(1, 42),
        diophantine_solution(-1, 42),
        diophantine_solution(2, 42),
        diophantine_solution(-2, 42)
    ]
    @test eltype(diophantine_anyx_oney(42)) == DiophantineSolutionXY{Int}

    @test collect(take(diophantine_anyx_oney(big(42)), 5)) == [
        diophantine_solution(big(0), big(42)),
        diophantine_solution(big(1), big(42)),
        diophantine_solution(big(-1), big(42)),
        diophantine_solution(big(2), big(42)),
        diophantine_solution(big(-2), big(42))
    ]
    @test eltype(diophantine_anyx_oney(big(42))) == DiophantineSolutionXY{BigInt}
end

function test_diophantine_solutions_linearx_lineary()
    @test collect(take(diophantine_linearx_lineary(2, 0, -3, 0), 5)) == [
        diophantine_solution(0, 0),
        diophantine_solution(2, -3),
        diophantine_solution(-2, 3),
        diophantine_solution(4, -6),
        diophantine_solution(-4, 6)
    ]
    @test eltype(diophantine_linearx_lineary(2, 0, -3, 0)) == DiophantineSolutionXY{Int}

    @test collect(take(diophantine_linearx_lineary(big(2), big(0), big(-3), big(0)), 5)) == [
        diophantine_solution(big(0), big(0)),
        diophantine_solution(big(2), big(-3)),
        diophantine_solution(big(-2), big(3)),
        diophantine_solution(big(4), big(-6)),
        diophantine_solution(big(-4), big(6))
    ]
    @test eltype(diophantine_linearx_lineary(big(2), big(0), big(-3), big(0))) == DiophantineSolutionXY{BigInt}
end

function test_diophantine_solutions_quadraticx_quadraticy()
    @test collect(take(diophantine_quadraticx_quadraticy(1, 2, 3, -1, 3, 2), 5)) == [
        diophantine_solution(3, 2),
        diophantine_solution(6, 4),
        diophantine_solution(2, -2),
        diophantine_solution(11, 4),
        diophantine_solution(3, -8)
    ]
    @test eltype(diophantine_quadraticx_quadraticy(1, 2, 3, -1, 3, 2)) == DiophantineSolutionXY{Int}

    @test collect(take(diophantine_quadraticx_quadraticy(big(1), big(2), big(3), big(-1), big(3), big(2)), 5)) == [
        diophantine_solution(big(3), big(2)),
        diophantine_solution(big(6), big(4)),
        diophantine_solution(big(2), big(-2)),
        diophantine_solution(big(11), big(4)),
        diophantine_solution(big(3), big(-8))
    ]
    @test eltype(diophantine_quadraticx_quadraticy(big(1), big(2), big(3), big(-1), big(3), big(2))) == DiophantineSolutionXY{BigInt}
end
