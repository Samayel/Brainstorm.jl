function test_combination_combinations()
    @test collect(combinations(Int[], 0)) == Array{Int64,1}[[]]
    @test length(combinations(Int[], 0)) == 1
    @test eltype(combinations(Int[], 0)) == Array{Int64,1}

    @test collect(combinations(Int[], 1)) == Array{Int64,1}[]
    @test length(combinations(Int[], 1)) == 0
    @test eltype(combinations(Int[], 1)) == Array{Int64,1}

    @test collect(combinations(["a", "b", "c", "d"], 2)) == Array[
        ["a", "b"],
        ["a", "c"],
        ["a", "d"],
        ["b", "c"],
        ["b", "d"],
        ["c", "d"],
    ]
    @test length(combinations(["a", "b", "c", "d"], 2)) == 6
    @test eltype(combinations(["a", "b", "c", "d"], 2)) == Array{ASCIIString,1}

    @test collect(combinations(["a", "b"], 3)) == Array{ASCIIString,1}[]
    @test length(combinations(["a", "b"], 3)) == 0
end

function test_combination_combinations_with_repetition()
    @test collect(combinations_with_repetition(Int[], 0)) == Array{Int64,1}[[]]
    @test length(combinations_with_repetition(Int[], 0)) == 1
    @test eltype(combinations_with_repetition(Int[], 0)) == Array{Int64,1}

    @test collect(combinations_with_repetition(Int[], 1)) == Array{Int64,1}[]
    @test length(combinations_with_repetition(Int[], 1)) == 0
    @test eltype(combinations_with_repetition(Int[], 1)) == Array{Int64,1}

    @test collect(combinations_with_repetition(["a", "b", "c", "d"], 2)) == Array[
        ["a", "a"],
        ["a", "b"],
        ["a", "c"],
        ["a", "d"],
        ["b", "b"],
        ["b", "c"],
        ["b", "d"],
        ["c", "c"],
        ["c", "d"],
        ["d", "d"],
    ]
    @test length(combinations_with_repetition(["a", "b", "c", "d"], 2)) == 10
    @test eltype(combinations_with_repetition(["a", "b", "c", "d"], 2)) == Array{ASCIIString,1}

    @test collect(combinations_with_repetition(["a", "b"], 3)) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "b"],
        ["b", "b", "b"],
    ]
    @test length(combinations_with_repetition(["a", "b"], 3)) == 4
end

function test_combination_all()
    print(rpad("Math.Combinatorics.Combination...", 50, ' '))

    test_combination_combinations()
    test_combination_combinations_with_repetition()

    println("PASS")
end
