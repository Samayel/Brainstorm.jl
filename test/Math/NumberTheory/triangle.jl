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

    test_triangle_primitive_pythagorean_triples()

    println("PASS")
end
