function test_combination_combinations()
    @test collect(combinations(Int[], 0, :unique)) == Array{Int64,1}[[]]
    @test length(combinations(Int[], 0, :unique)) == 1
    @test eltype(combinations(Int[], 0, :unique)) == Array{Int64,1}

    @test collect(combinations(Int[], 1, :unique)) == Array{Int64,1}[]
    @test length(combinations(Int[], 1, :unique)) == 0
    @test eltype(combinations(Int[], 1, :unique)) == Array{Int64,1}

    @test collect(combinations(["a", "b", "c", "d"], 2, :unique)) == Array[
        ["a", "b"],
        ["a", "c"],
        ["a", "d"],
        ["b", "c"],
        ["b", "d"],
        ["c", "d"],
    ]
    @test length(combinations(["a", "b", "c", "d"], 2, :unique)) == 6
    @test eltype(combinations(["a", "b", "c", "d"], 2, :unique)) == Array{ASCIIString,1}

    @test collect(combinations(["a", "b"], 3, :unique)) == Array{ASCIIString,1}[]
    @test length(combinations(["a", "b"], 3, :unique)) == 0
end

function test_combination_combinations_with_repetition()
    @test collect(combinations(Int[], 0, :repetition)) == Array{Int64,1}[[]]
    @test length(combinations(Int[], 0, :repetition)) == 1
    @test eltype(combinations(Int[], 0, :repetition)) == Array{Int64,1}

    @test collect(combinations(Int[], 1, :repetition)) == Array{Int64,1}[]
    @test length(combinations(Int[], 1, :repetition)) == 0
    @test eltype(combinations(Int[], 1, :repetition)) == Array{Int64,1}

    @test collect(combinations(["a", "b", "c", "d"], 2, :repetition)) == Array[
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
    @test length(combinations(["a", "b", "c", "d"], 2, :repetition)) == 10
    @test eltype(combinations(["a", "b", "c", "d"], 2, :repetition)) == Array{ASCIIString,1}

    @test collect(combinations(["a", "b"], 3, :repetition)) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "b"],
        ["b", "b", "b"],
    ]
    @test length(combinations(["a", "b"], 3, :repetition)) == 4
end

function test_combination_all()
    print(rpad("Math.Combinatorics.Combination...", 50, ' '))

    test_combination_combinations()
    test_combination_combinations_with_repetition()

    println("PASS")
end
