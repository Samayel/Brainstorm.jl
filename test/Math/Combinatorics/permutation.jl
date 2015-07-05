function test_permutation_permutations()
    @test collect(permutations(Int[], :unique)) == Array{Int64,1}[[]]
    @test length(permutations(Int[], :unique)) == 1
    @test eltype(permutations(Int[], :unique)) == Array{Int64,1}

    @test collect(permutations(["a", "b", "c"], :unique)) == Array[
        ["a", "b", "c"],
        ["a", "c", "b"],
        ["b", "a", "c"],
        ["b", "c", "a"],
        ["c", "a", "b"],
        ["c", "b", "a"],
    ]
    @test length(permutations(["a", "b", "c"], :unique)) == 6
    @test eltype(permutations(["a", "b", "c"], :unique)) == Array{ASCIIString,1}
end

function test_permutation_permutations_with_repetition()
    @test collect(permutations(Int[], :repetition)) == Array{Int64,1}[[]]
    @test length(permutations(Int[], :repetition)) == 1
    @test eltype(permutations(Int[], :repetition)) == Array{Int64,1}

    @test collect(permutations(["a", "b", "c"], :repetition)) == Array[
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
    @test length(permutations(["a", "b", "c"], :repetition)) == 27
    @test eltype(permutations(["a", "b", "c"], :repetition)) == Array{ASCIIString,1}
end

function test_permutation_kpermutations()
    @test collect(permutations(Int[], 0, :unique)) == Array{Int64,1}[[]]
    @test length(permutations(Int[], 0, :unique)) == 1
    @test eltype(permutations(Int[], 0, :unique)) == Array{Int64,1}

    @test collect(permutations(Int[], 1, :unique)) == Array{Int64,1}[]
    @test length(permutations(Int[], 1, :unique)) == 0
    @test eltype(permutations(Int[], 1, :unique)) == Array{Int64,1}

    @test collect(permutations(["a", "b", "c", "d"], 2, :unique)) == Array[
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
    @test length(permutations(["a", "b", "c", "d"], 2, :unique)) == 12
    @test eltype(permutations(["a", "b", "c", "d"], 2, :unique)) == Array{ASCIIString,1}

    @test collect(permutations(["a", "b", "c", "d"], 3, :unique)) == Array[
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
    @test length(permutations(["a", "b", "c", "d"], 3, :unique)) == 24
    @test eltype(permutations(["a", "b", "c", "d"], 3, :unique)) == Array{ASCIIString,1}

    @test collect(permutations(["a", "b"], 3, :unique)) == Array{ASCIIString,1}[]
    @test length(permutations(["a", "b"], 3, :unique)) == 0
end

function test_permutation_kpermutations_with_repetition()
    @test collect(permutations(Int[], 0, :repetition)) == Array{Int64,1}[[]]
    @test length(permutations(Int[], 0, :repetition)) == 1
    @test eltype(permutations(Int[], 0, :repetition)) == Array{Int64,1}

    @test collect(permutations(Int[], 1, :repetition)) == Array{Int64,1}[]
    @test length(permutations(Int[], 1, :repetition)) == 0
    @test eltype(permutations(Int[], 1, :repetition)) == Array{Int64,1}

    @test collect(permutations(["a", "b", "c", "d"], 2, :repetition)) == Array[
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
    @test length(permutations(["a", "b", "c", "d"], 2, :repetition)) == 4^2
    @test eltype(permutations(["a", "b", "c", "d"], 2, :repetition)) == Array{ASCIIString,1}

    @test collect(permutations(["a", "b"], 3, :repetition)) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "a"],
        ["a", "b", "b"],
        ["b", "a", "a"],
        ["b", "a", "b"],
        ["b", "b", "a"],
        ["b", "b", "b"],
    ]
    @test length(permutations(["a", "b"], 3, :repetition)) == 2^3
end

function test_permutation_all()
    print(rpad("Math.Combinatorics.Permutation...", 50, ' '))

    test_permutation_permutations()
    test_permutation_permutations_with_repetition()
    test_permutation_kpermutations()
    test_permutation_kpermutations_with_repetition()

    println("PASS")
end
