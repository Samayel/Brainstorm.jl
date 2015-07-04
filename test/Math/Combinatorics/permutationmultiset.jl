function test_permutationmultiset_permutations_of_multiset()
    @test collect(permutations_of_multiset(Int[], Int[])) == Array{Int64,1}[[]]
    @test length(permutations_of_multiset(Int[], Int[])) == 1
    @test eltype(permutations_of_multiset(Int[], Int[])) == Array{Int64,1}

    @test collect(permutations_of_multiset(["a", "b"], [2, 1])) == Array[
        ["a", "a", "b"],
        ["a", "b", "a"],
        ["b", "a", "a"],
    ]
    @test length(permutations_of_multiset(["a", "b"], [2, 1])) == 3
    @test eltype(permutations_of_multiset(["a", "b"], [2, 1])) == Array{ASCIIString,1}

    @test length(permutations_of_multiset(["M","I","S","P"], [1,4,4,2])) == 34650

    @test collect(permutations_of_multiset(Int[], Int[], 0)) == Array{Int64,1}[[]]
    @test eltype(permutations_of_multiset(Int[], Int[], 0)) == Array{Int64,1}

    @test collect(permutations_of_multiset(Int[], Int[], 1)) == Array{Int64,1}[]
    @test eltype(permutations_of_multiset(Int[], Int[], 1)) == Array{Int64,1}

    @test collect(permutations_of_multiset(["a", "b"], [3, 2], 3)) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "a"],
        ["a", "b", "b"],
        ["b", "a", "a"],
        ["b", "a", "b"],
        ["b", "b", "a"],
    ]
    @test eltype(permutations_of_multiset(["a", "b"], [3, 2], 3)) == Array{ASCIIString,1}
end

function test_permutationmultiset_all()
    print(rpad("Math.Combinatorics.PermutationMultiset...", 50, ' '))

    test_permutationmultiset_permutations_of_multiset()

    println("PASS")
end
