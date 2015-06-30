function test_vector_rotations()
    @test collect(rotations([1,2,3])) == Array{Int,1}[[1,2,3],[2,3,1],[3,1,2]]
    @test eltype(rotations([1,2,3])) == Array{Int,1}
    @test length(rotations([1,2,3])) == 3
end

function test_vector_all()
    print(rpad("DataStructure.Vector...", 50, ' '))

    test_vector_rotations()

    println("PASS")
end
