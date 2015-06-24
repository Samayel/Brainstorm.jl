function test_iterators_takewhile()
    @test collect(takewhile(x -> x^2 < 1, 1:10)) == []
    @test collect(takewhile(x -> x^2 < 25, 1:10)) == [1, 2, 3, 4]
    @test collect(takewhile(x -> x^2 < 1000, 1:10)) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @test eltype(takewhile(_ -> true, 1:10)) == typeof(1)

    @test collect(takewhile(1:10) do x; x^2 < 25; end) == [1, 2, 3, 4]
end

function test_iterators_dropwhile()
    @test collect(dropwhile(x -> x^2 < 1, 1:10)) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @test collect(dropwhile(x -> x^2 < 25, 1:10)) == [5, 6, 7, 8, 9, 10]
    @test collect(dropwhile(x -> x^2 < 1000, 1:10)) == []
    @test eltype(dropwhile(_ -> true, 1:10)) == typeof(1)

    @test collect(dropwhile(1:10) do x; x^2 < 25; end) == [5, 6, 7, 8, 9, 10]
end

function test_iterators_all()
    print("DataStructure.Iterators... ")

    test_iterators_takewhile()
    test_iterators_dropwhile()

    println("PASS")
end
