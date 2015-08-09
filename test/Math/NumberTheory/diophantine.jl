include("diophantine_solution.jl")
include("diophantine_linear.jl")
include("diophantine_quadratic.jl")

function test_diophantine_all()
    print(rpad("Math.NumberTheory.Diophantine...", 50, ' '))

    test_diophantine_solutions()
    test_diophantine_solutions_nonex_noney()
    test_diophantine_solutions_anyx_anyy()
    test_diophantine_solutions_onex_anyy()
    test_diophantine_solutions_anyx_oney()
    test_diophantine_solutions_somex_somey_anyt()

    test_diophantine_solve_diophantine_linear()
    test_diophantine_solve_diophantine_quadratic()

    println("PASS")
end
