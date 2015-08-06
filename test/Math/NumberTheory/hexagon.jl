function test_hexagon_ishexagonal()
    @test find([ishexagonal(i) for i = 1:1000]) == [1, 6, 15, 28, 45, 66, 91, 120, 153, 190, 231, 276, 325, 378, 435, 496, 561, 630, 703, 780, 861, 946]
end

function test_hexagon_nthhexagonal()
    @test nthhexagonal(1) == 1
    @test nthhexagonal(2) == 6
    @test nthhexagonal(10) == 190
end

function test_hexagon_nhexagonal()
    @test nhexagonal(10) == [1, 6, 15, 28, 45, 66, 91, 120, 153, 190]
    @test eltype(nhexagonal(10)) == Int
    @test eltype(nhexagonal(10, BigInt)) == BigInt
end

function test_hexagon_somehexagonal()
    @test collect(somehexagonal(90)) == [1, 6, 15, 28, 45, 66]
    @test collect(somehexagonal(91)) == [1, 6, 15, 28, 45, 66, 91]
    @test eltype(somehexagonal(91)) == Int
    @test eltype(somehexagonal(big(91))) == BigInt
end

function test_hexagon_exacthexagonal()
    @test collect(exacthexagonal(10)) == [1, 6, 15, 28, 45, 66, 91, 120, 153, 190]
    @test eltype(exacthexagonal(10)) == Int
    @test eltype(exacthexagonal(10, BigInt)) == BigInt
end

function test_hexagon_all()
    print(rpad("Math.NumberTheory.Hexagon...", 50, ' '))

    test_hexagon_ishexagonal()
    test_hexagon_nthhexagonal()
    test_hexagon_nhexagonal()
    test_hexagon_somehexagonal()
    test_hexagon_exacthexagonal()

    println("PASS")
end
