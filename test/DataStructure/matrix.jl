function test_matrix_rows()
    @test rows([1 2; 3 4]) == Array[[1,2],[3,4]]
end

function test_matrix_cols()
    @test cols([1 2; 3 4]) == Array[[1,3],[2,4]]
end

function test_matrix_diags()
    @test diags([1 2; 3 4]) == Array[[3],[1,4],[2]]
end

function test_matrix_antidiags()
    @test antidiags([1 2; 3 4]) == Array[[1],[2,3],[4]]
end

function test_matrix_all()
    print(rpad("DataStructure.Matrix...", 50, ' '))

    test_matrix_rows()
    test_matrix_cols()
    test_matrix_diags()
    test_matrix_antidiags()

    println("PASS")
end
