function test_primes_iscoprime()
    @test iscoprime(1, 3) == true
    @test iscoprime(2, 3) == true
    @test iscoprime(11*13*17, 13*17*19) == false
    @test iscoprime(2*3, 5*7) == true
end

function test_primes_primes()
    @test primes(10) == [2, 3, 5, 7]
    @test primes(11) == [2, 3, 5, 7, 11]
    @test primes(1, 1) == primes(1:1) == Int[]
    @test primes(10, 10) == primes(10:10) == Int[]
    @test primes(10, 20) == primes(10:20) == [11, 13, 17, 19]
    @test primes(11, 19) == primes(11:19) == [11, 13, 17, 19]
    @test primes(1000, 1100) == primes(1000:1100) == [1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097]
    @test eltype(primes(10)) == typeof(2)
    @test eltype(primes(10, 20)) == eltype(primes(10:20)) == typeof(11)
end

function test_primes_primesmask()
    @test primesmask(100000) == primesmask(1:100000) == [isprime(i) for i in 1:100000]
    @test primesmask(2:100000) == [isprime(i) for i in 2:100000]
    @test primesmask(1000:100000) == [isprime(i) for i in 1000:100000]
    @test primesmask(1009:100000) == [isprime(i) for i in 1009:100000]
    @test typeof(primesmask(100000)) == typeof(primesmask(1:100000)) == BitVector
end

function test_primes_primepi()
    @test primepi(10) == primepi(1:10) == primepi(2:10) == 4
    @test primepi(11) == primepi(1:11) == primepi(2:11) == 5
    @test primepi(10000) == primepi(1:10000) == primepi(2:10000) == 1229
    @test primepi(10, 20) == primepi(10:20) == 4
    @test primepi(11, 19) == primepi(11:19) == 4
end

function test_primes_nthprime()
    p = primes(10000)
    @test [nthprime(i) for i in 1:1000] == [p[i] for i in 1:1000]
    @test [nthprime(a, a + 100) for a in 1:1000] ==  [nthprime(a:(a+100)) for a in 1:1000] == [p[a:(a+100)] for a in 1:1000]
    @test typeof(nthprime(100)) == eltype(nthprime(1, 100)) == eltype(nthprime(1:100)) == typeof(100)
end

function test_primes_nextprime()
    p = primes(2000)
    @test [nextprime(i) for i in -1:1000] == [first(dropwhile(p -> p <= i, p)) for i in -1:1000]
    @test typeof(nextprime(3)) == typeof(3)
    @test typeof(nextprime(big(3))) == typeof(big(3))
end

function test_primes_prevprime()
    @test prevprime(0) == 0
    @test prevprime(2) == 0
    p = reverse(primes(2000))
    @test [prevprime(i) for i in 3:1000] == [first(dropwhile(p -> p >= i, p)) for i in 3:1000]
    @test typeof(prevprime(3)) == typeof(3)
    @test typeof(prevprime(big(3))) == typeof(big(3))
end

function test_primes_twinprimes()
    @test twinprimes(1000, 1050) == twinprimes(1000:1050) == [1019 1021; 1031 1033]
    @test length(twinprimes(20, 30)) == 0
end

function test_primes_all()
    label = "Math.NumberTheory.Primes..."
    print(rpad(label, 50, ' '))

    test_primes_iscoprime()
    test_primes_primes()
    test_primes_primesmask()
    test_primes_primepi()
    test_primes_nthprime()
    test_primes_nextprime()
    test_primes_prevprime()
    test_primes_twinprimes()

    println("PASS")
end
