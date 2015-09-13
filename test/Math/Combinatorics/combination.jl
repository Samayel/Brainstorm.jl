function test_combination_combinations()
    @test collect(combinations(Int[], 0, Val{:unique}())) == Array{Int64,1}[[]]
    @test length(combinations(Int[], 0, Val{:unique}())) == 1
    @test eltype(combinations(Int[], 0, Val{:unique}())) == Array{Int64,1}

    @test collect(combinations(Int[], 1, Val{:unique}())) == Array{Int64,1}[]
    @test length(combinations(Int[], 1, Val{:unique}())) == 0
    @test eltype(combinations(Int[], 1, Val{:unique}())) == Array{Int64,1}

    @test collect(combinations(["a", "b", "c", "d"], 2, Val{:unique}())) == Array[
        ["a", "b"],
        ["a", "c"],
        ["a", "d"],
        ["b", "c"],
        ["b", "d"],
        ["c", "d"],
    ]
    @test length(combinations(["a", "b", "c", "d"], 2, Val{:unique}())) == 6
    @test eltype(combinations(["a", "b", "c", "d"], 2, Val{:unique}())) == Array{ASCIIString,1}

    @test collect(combinations(["a", "b"], 3, Val{:unique}())) == Array{ASCIIString,1}[]
    @test length(combinations(["a", "b"], 3, Val{:unique}())) == 0
end

function test_combination_combinations_with_repetition()
    @test collect(combinations(Int[], 0, Val{:repeated}())) == Array{Int64,1}[[]]
    @test length(combinations(Int[], 0, Val{:repeated}())) == 1
    @test eltype(combinations(Int[], 0, Val{:repeated}())) == Array{Int64,1}

    @test collect(combinations(Int[], 1, Val{:repeated}())) == Array{Int64,1}[]
    @test length(combinations(Int[], 1, Val{:repeated}())) == 0
    @test eltype(combinations(Int[], 1, Val{:repeated}())) == Array{Int64,1}

    @test collect(combinations(["a", "b", "c", "d"], 2, Val{:repeated}())) == Array[
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
    @test length(combinations(["a", "b", "c", "d"], 2, Val{:repeated}())) == 10
    @test eltype(combinations(["a", "b", "c", "d"], 2, Val{:repeated}())) == Array{ASCIIString,1}

    @test collect(combinations(["a", "b"], 3, Val{:repeated}())) == Array[
        ["a", "a", "a"],
        ["a", "a", "b"],
        ["a", "b", "b"],
        ["b", "b", "b"],
    ]
    @test length(combinations(["a", "b"], 3, Val{:repeated}())) == 4
end

function test_combination_combinations_unknown_mode()
    @test_throws MethodError combinations(["a", "b", "c", "d"], 2, Val{:unknown}())
end

function test_combination_all()
    print(rpad("Math.Combinatorics.Combination...", 50, ' '))

    test_combination_combinations()
    test_combination_combinations_with_repetition()
    test_combination_combinations_unknown_mode()

    println("PASS")
end
