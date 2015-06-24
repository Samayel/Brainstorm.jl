function test_divisors_divisorcount()
    @test divisorcount(1) == 1
    @test divisorcount(2) == 2
    @test divisorcount(7) == 2
    @test divisorcount(20) == 6
    @test divisorcount(99) == 6
    @test divisorcount(100) == 9
end

function test_divisors_divisorsigma()
    @test divisorsigma(1) == 1
    @test divisorsigma(2) == 3
    @test divisorsigma(7) == 8
    @test divisorsigma(20) == 42
    @test divisorsigma(99) == 156
    @test divisorsigma(100) == 217

    @test_throws DomainError divisorsigma(1, -1)

    @test divisorsigma(1, 0) == 1
    @test divisorsigma(2, 0) == 2
    @test divisorsigma(7, 0) == 2
    @test divisorsigma(20, 0) == 6
    @test divisorsigma(99, 0) == 6
    @test divisorsigma(100, 0) == 9

    @test divisorsigma(1, 1) == 1
    @test divisorsigma(2, 1) == 3
    @test divisorsigma(7, 1) == 8
    @test divisorsigma(20, 1) == 42
    @test divisorsigma(99, 1) == 156
    @test divisorsigma(100, 1) == 217

    @test divisorsigma(1, 2) == 1
    @test divisorsigma(2, 2) == 5
    @test divisorsigma(7, 2) == 50
    @test divisorsigma(20, 2) == 546
    @test divisorsigma(99, 2) == 11102
    @test divisorsigma(100, 2) == 13671
end

function test_divisors_least_number_with_d_divisors()
    @test least_number_with_d_divisors(16) == 120
    @test least_number_with_d_divisors(240) == 720720
    @test least_number_with_d_divisors(4000) == 261891630000
    @test least_number_with_d_divisors(4001) == big(2)^4000
    @test least_number_with_d_divisors(4002) == 1474163083033391923200
end

function test_divisors_all()
    print("Math.NumberTheory.Divisors")
    print("... ")

    test_divisors_divisorcount()
    test_divisors_divisorsigma()
    test_divisors_least_number_with_d_divisors()

    println("PASS")
end
