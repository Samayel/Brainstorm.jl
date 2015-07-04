function test_variation_variations()
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

function test_variation_variations_with_repetition()
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

function test_variation_all()
    print(rpad("Math.Combinatorics.Variation...", 50, ' '))

    test_variation_variations()
    test_variation_variations_with_repetition()

    println("PASS")
end
