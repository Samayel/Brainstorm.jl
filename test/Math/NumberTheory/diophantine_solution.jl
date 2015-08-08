
function test_diophantine_solutions_listing()
    a = DiophantineSolution(1, 2)
    b = DiophantineSolution(7, 9)
    c = DiophantineSolution(-2, 42)
    solutions = [a, b, c]

    @test collect(diophantine_solutions(solutions)) == solutions
    @test eltype(diophantine_solutions(solutions)) == DiophantineSolution{Int}

    x = DiophantineSolution(big(0), big(0))
    @test eltype(diophantine_solutions([x])) == DiophantineSolution{BigInt}
end

function test_diophantine_solutions_nonex_noney()
    @test collect(DiophantineSolutionsNoneXNoneY{Int}()) == []
    @test eltype(DiophantineSolutionsNoneXNoneY{Int}()) == DiophantineSolution{Int}
    @test eltype(DiophantineSolutionsNoneXNoneY{BigInt}()) == DiophantineSolution{BigInt}
end

function test_diophantine_solutions_anyx_anyy()
end

function test_diophantine_solutions_onex_anyy()
    @test collect(take(DiophantineSolutionsOneXAnyY(42), 5)) == [
        DiophantineSolution(42, 0),
        DiophantineSolution(42, 1),
        DiophantineSolution(42, -1),
        DiophantineSolution(42, 2),
        DiophantineSolution(42, -2)
    ]
    @test eltype(DiophantineSolutionsOneXAnyY(42)) == DiophantineSolution{Int}

    @test collect(take(DiophantineSolutionsOneXAnyY(big(42)), 5)) == [
        DiophantineSolution(big(42), big(0)),
        DiophantineSolution(big(42), big(1)),
        DiophantineSolution(big(42), big(-1)),
        DiophantineSolution(big(42), big(2)),
        DiophantineSolution(big(42), big(-2))
    ]
    @test eltype(DiophantineSolutionsOneXAnyY(big(42))) == DiophantineSolution{BigInt}
end

function test_diophantine_solutions_anyx_oney()
    @test collect(take(DiophantineSolutionsAnyXOneY(42), 5)) == [
        DiophantineSolution(0, 42),
        DiophantineSolution(1, 42),
        DiophantineSolution(-1, 42),
        DiophantineSolution(2, 42),
        DiophantineSolution(-2, 42)
    ]
    @test eltype(DiophantineSolutionsAnyXOneY(42)) == DiophantineSolution{Int}

    @test collect(take(DiophantineSolutionsAnyXOneY(big(42)), 5)) == [
        DiophantineSolution(big(0), big(42)),
        DiophantineSolution(big(1), big(42)),
        DiophantineSolution(big(-1), big(42)),
        DiophantineSolution(big(2), big(42)),
        DiophantineSolution(big(-2), big(42))
    ]
    @test eltype(DiophantineSolutionsAnyXOneY(big(42))) == DiophantineSolution{BigInt}
end

function test_diophantine_solutions_somex_somey_anyt()
    xfunc = t ->  2t
    yfunc = t -> -3t

    @test collect(take(DiophantineSolutionsSomeXSomeYAnyT{Int}(xfunc, yfunc), 5)) == [
        DiophantineSolution(0, 0),
        DiophantineSolution(2, -3),
        DiophantineSolution(-2, 3),
        DiophantineSolution(4, -6),
        DiophantineSolution(-4, 6)
    ]
    @test eltype(DiophantineSolutionsSomeXSomeYAnyT{Int}(xfunc, yfunc)) == DiophantineSolution{Int}

    xfunc = t -> big(2t)
    yfunc = t -> big(-3t)

    @test collect(take(DiophantineSolutionsSomeXSomeYAnyT{BigInt}(xfunc, yfunc), 5)) == [
        DiophantineSolution(big(0), big(0)),
        DiophantineSolution(big(2), big(-3)),
        DiophantineSolution(big(-2), big(3)),
        DiophantineSolution(big(4), big(-6)),
        DiophantineSolution(big(-4), big(6))
    ]
    @test eltype(DiophantineSolutionsSomeXSomeYAnyT{BigInt}(xfunc, yfunc)) == DiophantineSolution{BigInt}
end
