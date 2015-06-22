function test_hailstone_nexthailstone()
    @test_throws DomainError nexthailstone(0)
    @test nexthailstone(1) == 4
    @test nexthailstone(2) == 1
end

function test_hailstone_hailstonelength()
    @test_throws DomainError hailstonelength(0)
    @test hailstonelength(1) == 1
    @test hailstonelength(13) == 10
end

function test_hailstone_allhailstone()
    @test_throws DomainError allhailstone(0)
    @test collect(allhailstone(1)) == [1]
    @test collect(allhailstone(13)) == [13, 40, 20, 10, 5, 16, 8, 4, 2, 1]
    @test eltype(allhailstone(1)) == typeof(1)
    @test eltype(allhailstone(13)) == typeof(13)
end

function test_hailstone_all()
    print("Math.NumberTheory.Hailstone... ")

    test_hailstone_nexthailstone()
    test_hailstone_hailstonelength()
    test_hailstone_allhailstone()

    println("PASS")
end
