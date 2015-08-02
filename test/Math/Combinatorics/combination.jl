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
    @test collect(combinations(Int[], 0, :repeated)) == Array{Int64,1}[[]]
    @test length(combinations(Int[], 0, :repeated)) == 1
    @test eltype(combinations(Int[], 0, :repeated)) == Array{Int64,1}

    @test collect(combinations(Int[], 1, :repeated)) == Array{Int64,1}[]
    @test length(combinations(Int[], 1, :repeated)) == 0
    @test eltype(combinations(Int[], 1, :repeated)) == Array{Int64,1}

    @test collect(combinations(["a", "b", "c", "d"], 2, :repeated)) == Array[
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
    @test length(combinations(["a", "b", "c", "d"], 2, :repeated)) == 10
    @test eltype(combinations(["a", "b", "c", "d"], 2, :repeated)) == Array{ASCIIString,1}

    @test collect(combinations(["a", "b"], 3, :repeated)) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "b"],
        ["b", "b", "b"],
    ]
    @test length(combinations(["a", "b"], 3, :repeated)) == 4
end

function test_combination_combinations_unknown_mode()
    @test_throws ErrorException combinations(["a", "b", "c", "d"], 2, :unknown)
end

function test_combination_all()
    print(rpad("Math.Combinatorics.Combination...", 50, ' '))

    test_combination_combinations()
    test_combination_combinations_with_repetition()
    test_combination_combinations_unknown_mode()

    println("PASS")
end
