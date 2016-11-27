function test_multicombination_combinations()
    @test collect(combinations(Int[], Int[], 0)) == Array{Int,1}[[]]
    @test length(combinations(Int[], Int[], 0)) == 1
    @test eltype(combinations(Int[], Int[], 0)) == Array{Int,1}

    @test collect(combinations(Int[], Int[], 1)) == Array{Int,1}[]
    @test length(combinations(Int[], Int[], 1)) == 0
    @test eltype(combinations(Int[], Int[], 1)) == Array{Int,1}

    @test collect(combinations(["a", "b"], [2, 1], 3)) == Array[
        ["a", "a", "b"],
    ]
    @test length(combinations(["a", "b"], [2, 1], 3)) == 1
    @test eltype(combinations(["a", "b"], [2, 1], 3)) == Array{String,1}

    @test collect(combinations(["a", "b"], [3, 2], 3)) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "b"],
    ]
    @test length(combinations(["a", "b"], [3, 2], 3)) == 3
    @test eltype(combinations(["a", "b"], [3, 2], 3)) == Array{String,1}

    @test collect(combinations(["P", "O", "E", "S"], [1, 1, 2, 5], 4)) == Array[
        ["P", "O", "E", "E"],
        ["P", "O", "E", "S"],
        ["P", "O", "S", "S"],
        ["P", "E", "E", "S"],
        ["P", "E", "S", "S"],
        ["P", "S", "S", "S"],
        ["O", "E", "E", "S"],
        ["O", "E", "S", "S"],
        ["O", "S", "S", "S"],
        ["E", "E", "S", "S"],
        ["E", "S", "S", "S"],
        ["S", "S", "S", "S"],
    ]
    @test length(combinations(["P", "O", "E", "S"], [1, 1, 2, 5], 4)) == 12
    @test eltype(combinations(["P", "O", "E", "S"], [1, 1, 2, 5], 4)) == Array{String,1}
end

function test_multicombination_all()
    print(rpad("Math.Combinatorics.Combination[Multiset]...", 50, ' '))

    test_multicombination_combinations()

    println("PASS")
end
