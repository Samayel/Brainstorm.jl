function test_combinatorics_permutations()
    @test collect(permutations(Int[])) == Array{Int64,1}[[]]
    @test length(permutations(Int[])) == 1
    @test eltype(permutations(Int[])) == Array{Int64,1}

    @test collect(permutations(["a", "b", "c"])) == Array[
        ["a", "b", "c"],
        ["a", "c", "b"],
        ["b", "a", "c"],
        ["b", "c", "a"],
        ["c", "a", "b"],
        ["c", "b", "a"],
    ]
    @test length(permutations(["a", "b", "c"])) == 6
    @test eltype(permutations(["a", "b", "c"])) == Array{ASCIIString,1}
end

function test_combinatorics_permutations_with_repetition()
    @test collect(permutations_with_repetition(Int[])) == Array{Int64,1}[[]]
    @test length(permutations_with_repetition(Int[])) == 1
    @test eltype(permutations_with_repetition(Int[])) == Array{Int64,1}

    @test collect(permutations_with_repetition(["a", "b", "c"])) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "a", "c"],
        ["a", "b", "a"],
        ["a", "b", "b"],
        ["a", "b", "c"],
        ["a", "c", "a"],
        ["a", "c", "b"],
        ["a", "c", "c"],
        ["b", "a", "a"],
        ["b", "a", "b"],
        ["b", "a", "c"],
        ["b", "b", "a"],
        ["b", "b", "b"],
        ["b", "b", "c"],
        ["b", "c", "a"],
        ["b", "c", "b"],
        ["b", "c", "c"],
        ["c", "a", "a"],
        ["c", "a", "b"],
        ["c", "a", "c"],
        ["c", "b", "a"],
        ["c", "b", "b"],
        ["c", "b", "c"],
        ["c", "c", "a"],
        ["c", "c", "b"],
        ["c", "c", "c"],
    ]
    @test length(permutations_with_repetition(["a", "b", "c"])) == 27
    @test eltype(permutations_with_repetition(["a", "b", "c"])) == Array{ASCIIString,1}
end

function test_combinatorics_variations()
    @test collect(variations(Int[], 0)) == Array{Int64,1}[[]]
    @test length(variations(Int[], 0)) == 1
    @test eltype(variations(Int[], 0)) == Array{Int64,1}

    @test collect(variations(Int[], 1)) == Array{Int64,1}[]
    @test length(variations(Int[], 1)) == 0
    @test eltype(variations(Int[], 1)) == Array{Int64,1}

    @test collect(variations(["a", "b", "c", "d"], 2)) == Array[
        ["a", "b"],
        ["a", "c"],
        ["a", "d"],
        ["b", "a"],
        ["b", "c"],
        ["b", "d"],
        ["c", "a"],
        ["c", "b"],
        ["c", "d"],
        ["d", "a"],
        ["d", "b"],
        ["d", "c"],
    ]
    @test length(variations(["a", "b", "c", "d"], 2)) == 12
    @test eltype(variations(["a", "b", "c", "d"], 2)) == Array{ASCIIString,1}

    @test collect(variations(["a", "b", "c", "d"], 3)) == Array[
        ["a", "b", "c"],
        ["a", "b", "d"],
        ["a", "c", "b"],
        ["a", "c", "d"],
        ["a", "d", "b"],
        ["a", "d", "c"],
        ["b", "a", "c"],
        ["b", "a", "d"],
        ["b", "c", "a"],
        ["b", "c", "d"],
        ["b", "d", "a"],
        ["b", "d", "c"],
        ["c", "a", "b"],
        ["c", "a", "d"],
        ["c", "b", "a"],
        ["c", "b", "d"],
        ["c", "d", "a"],
        ["c", "d", "b"],
        ["d", "a", "b"],
        ["d", "a", "c"],
        ["d", "b", "a"],
        ["d", "b", "c"],
        ["d", "c", "a"],
        ["d", "c", "b"],
    ]
    @test length(variations(["a", "b", "c", "d"], 3)) == 24
    @test eltype(variations(["a", "b", "c", "d"], 3)) == Array{ASCIIString,1}

    @test collect(variations(["a", "b"], 3)) == Array{ASCIIString,1}[]
    @test length(variations(["a", "b"], 3)) == 0
end

function test_combinatorics_variations_with_repetition()
    @test collect(variations_with_repetition(Int[], 0)) == Array{Int64,1}[[]]
    @test length(variations_with_repetition(Int[], 0)) == 1
    @test eltype(variations_with_repetition(Int[], 0)) == Array{Int64,1}

    @test collect(variations_with_repetition(Int[], 1)) == Array{Int64,1}[]
    @test length(variations_with_repetition(Int[], 1)) == 0
    @test eltype(variations_with_repetition(Int[], 1)) == Array{Int64,1}

    @test collect(variations_with_repetition(["a", "b", "c", "d"], 2)) == Array[
        ["a", "a"],
        ["a", "b"],
        ["a", "c"],
        ["a", "d"],
        ["b", "a"],
        ["b", "b"],
        ["b", "c"],
        ["b", "d"],
        ["c", "a"],
        ["c", "b"],
        ["c", "c"],
        ["c", "d"],
        ["d", "a"],
        ["d", "b"],
        ["d", "c"],
        ["d", "d"],
    ]
    @test length(variations_with_repetition(["a", "b", "c", "d"], 2)) == 4^2
    @test eltype(variations_with_repetition(["a", "b", "c", "d"], 2)) == Array{ASCIIString,1}

    @test collect(variations_with_repetition(["a", "b"], 3)) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "a"],
        ["a", "b", "b"],
        ["b", "a", "a"],
        ["b", "a", "b"],
        ["b", "b", "a"],
        ["b", "b", "b"],
    ]
    @test length(variations_with_repetition(["a", "b"], 3)) == 2^3
end

function test_combinatorics_combinations()
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

function test_combinatorics_combinations_with_repetition()
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

function test_combinatorics_all()
    print(rpad("Math.Combinatorics...", 50, ' '))

    test_combinatorics_permutations()
    test_combinatorics_permutations_with_repetition()

    test_combinatorics_variations()
    test_combinatorics_variations_with_repetition()

    test_combinatorics_combinations()
    test_combinatorics_combinations_with_repetition()

    println("PASS")
end
