function test_iterator_takewhile()
    @test collect(takewhile(x -> x^2 < 1, 1:10)) == []
    @test collect(takewhile(x -> x^2 < 25, 1:10)) == [1, 2, 3, 4]
    @test collect(takewhile(x -> x^2 < 1000, 1:10)) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @test eltype(takewhile(_ -> true, 1:10)) == typeof(1)

    @test collect(takewhile(1:10) do x; x^2 < 25; end) == [1, 2, 3, 4]
end

function test_iterator_dropwhile()
    @test collect(dropwhile(x -> x^2 < 1, 1:10)) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @test collect(dropwhile(x -> x^2 < 25, 1:10)) == [5, 6, 7, 8, 9, 10]
    @test collect(dropwhile(x -> x^2 < 1000, 1:10)) == []
    @test eltype(dropwhile(_ -> true, 1:10)) == typeof(1)

    @test collect(dropwhile(1:10) do x; x^2 < 25; end) == [5, 6, 7, 8, 9, 10]
end

function test_iterator_tmap()
    @test collect(tmap(x -> x + 1, Int, 1:10)) == [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    @test collect(tmap(x -> x + 1, BigInt, 1:10)) == [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    @test eltype(tmap(x -> x + 1, Int, 1:10)) == Int
    @test eltype(tmap(x -> x + 1, BigInt, 1:10)) == BigInt
    @test length(tmap(x -> x + 1, Int, 1:10)) == 10

    @test collect(tmap(+, Int, 1:5, 11:20)) == [12, 14, 16, 18, 20]
    @test length(tmap(+, Int, 1:5, 11:20)) == 5
end

create(it::DefaultNestedIterator{Array{Int,1}}, value) = begin
    f = filter(x -> x != value, it.source)
    length(f) > 1 ? nested(f, it.level + 1) : f
end
combine(::DefaultNestedIterator{Array{Int,1}}, outer, inner) = "$outer$inner"

Base.eltype(it::DefaultNestedIterator{Array{Int,1}}) = eltype(typeof(it))
Base.eltype(::Type{DefaultNestedIterator{Array{Int,1}}}) = String

function test_iterator_nested_iterator()
    @test collect(nested([big(1), big(2), big(3)])) == []

    @test collect(nested(collect(1:3))) == ["123","132","213","231","312","321"]
    @test eltype(nested(collect(1:3))) == String
end

immutable DigitPermutationIterator <: NestedIterator
    source::Array{Int,1}
    maxlen::Int
end

digitperm(s, l) = l == 1 ? s : DigitPermutationIterator(s, l)

create(it::DigitPermutationIterator, value) = begin
    f = filter(x -> x != value, it.source)
    (it.maxlen > 2 && length(f) > 1) ? digitperm(f, it.maxlen - 1) : f
end
combine(::DigitPermutationIterator, outer, inner) = "$outer$inner"

Base.eltype(it::DigitPermutationIterator) = eltype(typeof(it))
Base.eltype(::Type{DigitPermutationIterator}) = String

function test_iterator_nested_iterator2()
    @test collect(digitperm(collect(1:4), 2)) == ["12","13","14","21","23","24","31","32","34","41","42","43"]
    @test eltype(digitperm(collect(1:4), 2)) == String
end


function test_iterator_all()
    print(rpad("DataStructure.Iterator...", 50, ' '))

    test_iterator_takewhile()
    test_iterator_dropwhile()
    test_iterator_tmap()
    test_iterator_nested_iterator()
    test_iterator_nested_iterator2()

    println("PASS")
end
