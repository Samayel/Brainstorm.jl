function test_triangle_nthtriangle()
    @test nthtriangle(1) == 1
    @test nthtriangle(2) == 3
    @test nthtriangle(10) == 55
end

function test_triangle_ntriangle()
    @test ntriangle(10) == [1, 3, 6, 10, 15, 21, 28, 36, 45, 55]
    @test eltype(ntriangle(10)) == Int
    @test eltype(ntriangle(10, BigInt)) == BigInt
end

function test_triangle_sometriangle()
    @test collect(sometriangle(35)) == [1, 3, 6, 10, 15, 21, 28]
    @test collect(sometriangle(36)) == [1, 3, 6, 10, 15, 21, 28, 36]
    @test eltype(sometriangle(36)) == Int
    @test eltype(sometriangle(big(36))) == BigInt
end

function test_triangle_exacttriangle()
    @test collect(exacttriangle(10)) == [1, 3, 6, 10, 15, 21, 28, 36, 45, 55]
    @test eltype(exacttriangle(10)) == Int
    @test eltype(exacttriangle(10, BigInt)) == BigInt
end

function test_triangle_primitive_pythagorean_triples()
    @test collect(take(primitive_pythagorean_triples(), 13)) == Array{Int,1}[
        [3,4,5],
        [5,12,13],
        [21,20,29],
        [15,8,17],
        [7,24,25],
        [55,48,73],
        [45,28,53],
        [39,80,89],
        [119,120,169],
        [77,36,85],
        [33,56,65],
        [65,72,97],
        [35,12,37]
    ]
    @test eltype(primitive_pythagorean_triples()) == Array{Int,1}
    @test eltype(primitive_pythagorean_triples(BigInt)) == Array{BigInt,1}

    @test collect(primitive_pythagorean_triples(11)) == Array{Int,1}[]
    @test collect(primitive_pythagorean_triples(12)) == Array{Int,1}[[3,4,5]]
    @test collect(primitive_pythagorean_triples(100)) == Array{Int,1}[
        [3,4,5],
        [5,12,13],
        [21,20,29],
        [15,8,17],
        [7,24,25],
        [35,12,37],
        [9,40,41]
    ]
    @test eltype(primitive_pythagorean_triples(100)) == Array{Int,1}
    @test eltype(primitive_pythagorean_triples(big(100))) == Array{BigInt,1}

    @test count(_->true, primitive_pythagorean_triples(10)) == 0
    @test count(_->true, primitive_pythagorean_triples(100)) == 7
    @test count(_->true, primitive_pythagorean_triples(1000)) == 70
    @test count(_->true, primitive_pythagorean_triples(10000)) == 703
    @test count(_->true, primitive_pythagorean_triples(100000)) == 7026
    @test count(_->true, primitive_pythagorean_triples(1000000)) == 70229
end

function test_triangle_all()
    print(rpad("Math.NumberTheory.Triangle...", 50, ' '))

    test_triangle_nthtriangle()
    test_triangle_ntriangle()
    test_triangle_sometriangle()
    test_triangle_exacttriangle()

    test_triangle_primitive_pythagorean_triples()

    println("PASS")
end
