function test_factor_isperfectsquare()
    @test find([isperfectsquare(i) for i in 1:100]) == [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
end

function test_factor_factor()
    @test factor(147573952589676412927) == Dict{BigInt,Int}(193707721 => 1, 761838257287 => 1)
    @test factor((2^31-1)*(2^17-1)) == Dict((2^31-1) => 1, (2^17-1) => 1)
    @test factor((big(2)^31-1)^2) == Dict(big(2^31-1) => 2)

    primenumbers = primes(2^16)
    @test factor(reduce(*, big(1), primenumbers)) == Dict(p => 1 for p in primenumbers)

    @test typeof(factor(10, SortedDict{Int, Int})) == SortedDict{Int, Int, Base.Order.ForwardOrdering}
end

function test_factor_eulerphi()
    @test eulerphi(1) == 1
    @test eulerphi(2) == 1
    @test eulerphi(3) == 2
    @test eulerphi(9) == 6

    @test eulerphi(factor(1)) == 1
    @test eulerphi(factor(2)) == 1
    @test eulerphi(factor(3)) == 2
    @test eulerphi(factor(9)) == 6
end

function test_factor_divisorcount()
    @test divisorcount(1) == 1
    @test divisorcount(2) == 2
    @test divisorcount(7) == 2
    @test divisorcount(20) == 6
    @test divisorcount(99) == 6
    @test divisorcount(100) == 9

    @test divisorcount(factor(1)) == 1
    @test divisorcount(factor(2)) == 2
    @test divisorcount(factor(7)) == 2
    @test divisorcount(factor(20)) == 6
    @test divisorcount(factor(99)) == 6
    @test divisorcount(factor(100)) == 9
end

function test_factor_divisorsigma()
    @test divisorsigma(1) == 1
    @test divisorsigma(2) == 3
    @test divisorsigma(7) == 8
    @test divisorsigma(20) == 42
    @test divisorsigma(99) == 156
    @test divisorsigma(100) == 217

    @test divisorsigma(factor(1)) == 1
    @test divisorsigma(factor(2)) == 3
    @test divisorsigma(factor(7)) == 8
    @test divisorsigma(factor(20)) == 42
    @test divisorsigma(factor(99)) == 156
    @test divisorsigma(factor(100)) == 217

    @test_throws DomainError divisorsigma(1, -1)
    @test_throws ErrorException divisorsigma(factor(1), -1)
    
    @test divisorsigma(1, 0) == 1
    @test divisorsigma(2, 0) == 2
    @test divisorsigma(7, 0) == 2
    @test divisorsigma(20, 0) == 6
    @test divisorsigma(99, 0) == 6
    @test divisorsigma(100, 0) == 9

    @test divisorsigma(factor(1), 0) == 1
    @test divisorsigma(factor(2), 0) == 2
    @test divisorsigma(factor(7), 0) == 2
    @test divisorsigma(factor(20), 0) == 6
    @test divisorsigma(factor(99), 0) == 6
    @test divisorsigma(factor(100), 0) == 9

    @test divisorsigma(1, 1) == 1
    @test divisorsigma(2, 1) == 3
    @test divisorsigma(7, 1) == 8
    @test divisorsigma(20, 1) == 42
    @test divisorsigma(99, 1) == 156
    @test divisorsigma(100, 1) == 217

    @test divisorsigma(factor(1), 1) == 1
    @test divisorsigma(factor(2), 1) == 3
    @test divisorsigma(factor(7), 1) == 8
    @test divisorsigma(factor(20), 1) == 42
    @test divisorsigma(factor(99), 1) == 156
    @test divisorsigma(factor(100), 1) == 217

    @test divisorsigma(1, 2) == 1
    @test divisorsigma(2, 2) == 5
    @test divisorsigma(7, 2) == 50
    @test divisorsigma(20, 2) == 546
    @test divisorsigma(99, 2) == 11102
    @test divisorsigma(100, 2) == 13671

    @test divisorsigma(factor(1), 2) == 1
    @test divisorsigma(factor(2), 2) == 5
    @test divisorsigma(factor(7), 2) == 50
    @test divisorsigma(factor(20), 2) == 546
    @test divisorsigma(factor(99), 2) == 11102
    @test divisorsigma(factor(100), 2) == 13671
end

function test_factor_isperfect()
    @test find([isperfect(i) for i in 1:30]) == [6, 28]
end

function test_factor_isdeficient()
    @test find([isdeficient(i) for i in 1:30]) == [1:5;7:11;13:17;19;21:23;25:27;29]
end

function test_factor_isabundant()
    @test find([isabundant(i) for i in 1:30]) == [12, 18, 20, 24, 30]
end

function test_factor_primefactors()
    @test primefactors(1) == []
    @test primefactors(2^4)  == [2]
    @test primefactors(24) == [2, 3]
    @test primefactors(1001) == [7, 11, 13]
    @test primefactors(1013) == [1013]
end

function test_factor_factors()
    @test factors(24) == [1, 2, 3, 4, 6, 8, 12, 24]
    @test factors(24, true) == [1, -1, 2, -2, 3, -3, 4, -4, 6, -6, 8, -8, 12, -12, 24, -24]
end

function test_factor_least_number_with_d_divisors()
    @test least_number_with_d_divisors(16) == 120
    @test least_number_with_d_divisors(240) == 720720
    @test least_number_with_d_divisors(4000) == 261891630000
    @test least_number_with_d_divisors(4001) == big(2)^4000
    @test least_number_with_d_divisors(4002) == 1474163083033391923200
end

function test_factor_all()
    print(rpad("Math.NumberTheory.Factor...", 50, ' '))

    test_factor_isperfectsquare()
    test_factor_factor()
    test_factor_eulerphi()
    test_factor_divisorcount()
    test_factor_divisorsigma()
    test_factor_isperfect()
    test_factor_isdeficient()
    test_factor_isabundant()
    test_factor_primefactors()
    test_factor_factors()
    test_factor_least_number_with_d_divisors()

    println("PASS")
end
