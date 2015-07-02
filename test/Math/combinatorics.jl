function test_combinatorics_permutations()
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

function test_combinatorics_permutations_with_repetitions()
    @test collect(permutations_with_repetitions(["a", "b", "c"])) == Array[
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
    @test length(permutations_with_repetitions(["a", "b", "c"])) == 27
    @test eltype(permutations_with_repetitions(["a", "b", "c"])) == Array{ASCIIString,1}
end

function test_combinatorics_variations()
#=
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
=#
end

function test_combinatorics_variations_with_repetitions()
    @test collect(variations_with_repetitions(["a", "b", "c", "d"], 2)) == Array[
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
    @test length(variations_with_repetitions(["a", "b", "c", "d"], 2)) == 16
    @test eltype(variations_with_repetitions(["a", "b", "c", "d"], 2)) == Array{ASCIIString,1}
end

function test_combinatorics_combinations()
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
end

function test_combinatorics_combinations_with_repetitions()
    @test collect(combinations_with_repetitions(["a", "b", "c", "d"], 2)) == Array[
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
    @test length(combinations_with_repetitions(["a", "b", "c", "d"], 2)) == 10
    @test eltype(combinations_with_repetitions(["a", "b", "c", "d"], 2)) == Array{ASCIIString,1}
end

function test_combinatorics_all()
    print(rpad("Math.Combinatorics...", 50, ' '))

    test_combinatorics_permutations()
    test_combinatorics_permutations_with_repetitions()

    test_combinatorics_variations()
    test_combinatorics_variations_with_repetitions()

    test_combinatorics_combinations()
    test_combinatorics_combinations_with_repetitions()

    println("PASS")
end
