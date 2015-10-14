function test_multipermutation_permutations()
    @test collect(permutations(Int[], Int[])) == Array{Int,1}[[]]
    @test length(permutations(Int[], Int[])) == 1
    @test eltype(permutations(Int[], Int[])) == Array{Int,1}

    @test collect(permutations(["a", "b"], [2, 1])) == Array[
        ["a", "a", "b"],
        ["a", "b", "a"],
        ["b", "a", "a"],
    ]
    @test length(permutations(["a", "b"], [2, 1])) == 3
    @test eltype(permutations(["a", "b"], [2, 1])) == Array{ASCIIString,1}

    @test length(permutations(["M","I","S","P"], [1,4,4,2])) == 34650
    @test length(permutations([:right,:down], [20,20])) == 137846528820

    @test collect(permutations(Int[], Int[], 0)) == Array{Int,1}[[]]
    @test length(permutations(Int[], Int[], 0)) == 1
    @test eltype(permutations(Int[], Int[], 0)) == Array{Int,1}

    @test collect(permutations(Int[], Int[], 1)) == Array{Int,1}[]
    @test length(permutations(Int[], Int[], 1)) == 0
    @test eltype(permutations(Int[], Int[], 1)) == Array{Int,1}

    @test collect(permutations(["a", "b"], [3, 2], 3)) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "a"],
        ["a", "b", "b"],
        ["b", "a", "a"],
        ["b", "a", "b"],
        ["b", "b", "a"],
    ]
    @test length(permutations(["a", "b"], [3, 2], 3)) == 7
    @test eltype(permutations(["a", "b"], [3, 2], 3)) == Array{ASCIIString,1}

    @test length(permutations(["M","I","S","P"], [1,4,4,2], 11)) == 34650
end

function test_multipermutation_all()
    print(rpad("Math.Combinatorics.Permutation[Multiset]...", 50, ' '))

    test_multipermutation_permutations()

    println("PASS")
end
