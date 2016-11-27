function test_permutation_permutations()
    @test collect(permutations(Int[], Val{:unique})) == Array{Int,1}[[]]
    @test length(permutations(Int[], Val{:unique})) == 1
    @test eltype(permutations(Int[], Val{:unique})) == Array{Int,1}

    @test collect(permutations(["a", "b", "c"], Val{:unique})) == Array[
        ["a", "b", "c"],
        ["a", "c", "b"],
        ["b", "a", "c"],
        ["b", "c", "a"],
        ["c", "a", "b"],
        ["c", "b", "a"],
    ]
    @test length(permutations(["a", "b", "c"], Val{:unique})) == 6
    @test eltype(permutations(["a", "b", "c"], Val{:unique})) == Array{String,1}
end

function test_permutation_permutations_with_repetition()
    @test collect(permutations(Int[], Val{:repeated})) == Array{Int,1}[[]]
    @test length(permutations(Int[], Val{:repeated})) == 1
    @test eltype(permutations(Int[], Val{:repeated})) == Array{Int,1}

    @test collect(permutations(["a", "b", "c"], Val{:repeated})) == Array[
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
    @test length(permutations(["a", "b", "c"], Val{:repeated})) == 27
    @test eltype(permutations(["a", "b", "c"], Val{:repeated})) == Array{String,1}
end

function test_permutation_permutations_unknown_mode()
    @test_throws MethodError permutations(["a", "b", "c"], Val{:unknown})
end

function test_permutation_kpermutations()
    @test collect(permutations(Int[], 0, Val{:unique})) == Array{Int,1}[[]]
    @test length(permutations(Int[], 0, Val{:unique})) == 1
    @test eltype(permutations(Int[], 0, Val{:unique})) == Array{Int,1}

    @test collect(permutations(Int[], 1, Val{:unique})) == Array{Int,1}[]
    @test length(permutations(Int[], 1, Val{:unique})) == 0
    @test eltype(permutations(Int[], 1, Val{:unique})) == Array{Int,1}

    @test collect(permutations(["a", "b", "c", "d"], 2, Val{:unique})) == Array[
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
    @test length(permutations(["a", "b", "c", "d"], 2, Val{:unique})) == 12
    @test eltype(permutations(["a", "b", "c", "d"], 2, Val{:unique})) == Array{String,1}

    @test collect(permutations(["a", "b", "c", "d"], 3, Val{:unique})) == Array[
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
    @test length(permutations(["a", "b", "c", "d"], 3, Val{:unique})) == 24
    @test eltype(permutations(["a", "b", "c", "d"], 3, Val{:unique})) == Array{String,1}

    @test collect(permutations(["a", "b"], 3, Val{:unique})) == Array{String,1}[]
    @test length(permutations(["a", "b"], 3, Val{:unique})) == 0
end

function test_permutation_kpermutations_with_repetition()
    @test collect(permutations(Int[], 0, Val{:repeated})) == Array{Int,1}[[]]
    @test length(permutations(Int[], 0, Val{:repeated})) == 1
    @test eltype(permutations(Int[], 0, Val{:repeated})) == Array{Int,1}

    @test collect(permutations(Int[], 1, Val{:repeated})) == Array{Int,1}[]
    @test length(permutations(Int[], 1, Val{:repeated})) == 0
    @test eltype(permutations(Int[], 1, Val{:repeated})) == Array{Int,1}

    @test collect(permutations(["a", "b", "c", "d"], 2, Val{:repeated})) == Array[
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
    @test length(permutations(["a", "b", "c", "d"], 2, Val{:repeated})) == 4^2
    @test eltype(permutations(["a", "b", "c", "d"], 2, Val{:repeated})) == Array{String,1}

    @test collect(permutations(["a", "b"], 3, Val{:repeated})) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "a"],
        ["a", "b", "b"],
        ["b", "a", "a"],
        ["b", "a", "b"],
        ["b", "b", "a"],
        ["b", "b", "b"],
    ]
    @test length(permutations(["a", "b"], 3, Val{:repeated})) == 2^3
end

function test_permutation_kpermutations_unknown_mode()
    @test_throws ErrorException permutations(["a", "b", "c", "d"], 2, Val{:unknown})
end

function test_permutation_all()
    print(rpad("Math.Combinatorics.Permutation...", 50, ' '))

    test_permutation_permutations()
    test_permutation_permutations_with_repetition()
    test_permutation_permutations_unknown_mode()
    test_permutation_kpermutations()
    test_permutation_kpermutations_with_repetition()
    test_permutation_kpermutations_unknown_mode()

    println("PASS")
end
