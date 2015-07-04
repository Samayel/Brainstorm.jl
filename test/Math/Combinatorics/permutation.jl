function test_permutation_permutations()
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

function test_permutation_permutations_with_repetition()
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

function test_permutation_all()
    print(rpad("Math.Combinatorics.Permutation...", 50, ' '))

    test_permutation_permutations()
    test_permutation_permutations_with_repetition()

    println("PASS")
end
