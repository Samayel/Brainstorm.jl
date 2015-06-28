function test_primes_factorization()
    @test factorization(147573952589676412927) ==
        @compat Dict{Int, Int}(193707721 => 1, 761838257287 => 1)
    @test factorization((big(2)^31-1)*(big(2)^17-1)) ==
        @compat Dict(big(2^31-1) => 1, big(2^17-1) => 1)
    fastprimes() && @test factorization((big(2)^31-1)^2) ==
        @compat Dict(big(2^31-1) => 2)
end

function test_primes_genprimes()
    @test genprimes(10) == [2, 3, 5, 7]
    @test genprimes(11) == [2, 3, 5, 7, 11]
    @test genprimes(1, 1) == Int[]
    @test genprimes(10, 10) == Int[]
    @test genprimes(10, 20) == [11, 13, 17, 19]
    @test genprimes(11, 19) == [11, 13, 17, 19]
    @test genprimes(1000, 1100) == [1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097]
    @test genprimes(10^6) == Base.primes(10^6)
    @test eltype(genprimes(10)) == typeof(2)
    @test eltype(genprimes(10, 20)) == typeof(11)
end

function test_primes_countprimes()
    @test countprimes(10, 20) == 4
    @test countprimes(11, 19) == 4
end

function test_primes_primepi()
    @test primepi(10) == 4
    @test primepi(11) == 5
    @test primepi(10000) == 1229
end

function test_primes_nextprime()
    @test nextprime(-1) == 2
    @test nextprime(0) == 2
    @test nextprime(1) == 2
    @test nextprime(2) == 3
    @test nextprime(3) == 5
    @test nextprime(5) == 7
    @test nextprime(1000) == 1009
end

function test_primes_prevprime()
    @test_throws DomainError prevprime(-1)
    @test_throws DomainError prevprime(0)
    @test_throws DomainError prevprime(1)
    @test_throws DomainError prevprime(2)
    @test prevprime(3) == 2
    @test prevprime(5) == 3
    @test prevprime(1000) == 997
end

function test_primes_nprimes()
    @test nprimes(10) == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    @test nprimes(10, 100) == [101, 103, 107, 109, 113, 127, 131, 137, 139, 149]
    @test eltype(nprimes(10)) == typeof(2)
    @test eltype(nprimes(10, 100)) == typeof(101)
end

function test_primes_nthprime()
    @test nthprime(1000) == 7919
end

function test_primes_someprimes()
    @test collect(someprimes(10)) == [2, 3, 5, 7]
    @test collect(someprimes(11)) == [2, 3, 5, 7, 11]
    @test collect(someprimes(10, 20)) == [11, 13, 17, 19]
    @test collect(someprimes(11, 19)) == [11, 13, 17, 19]
    @test eltype(someprimes(10)) == typeof(2)
    @test eltype(someprimes(10, 20)) == typeof(11)
end

function test_primes_twinprimes()
    @test twinprimes(1000, 1050) == [1019 1021; 1031 1033]
    @test length(twinprimes(20, 30)) == 0
end

function test_primes_coprime()
    @test coprime(1, 3) == true
    @test coprime(2, 3) == true
    @test coprime(11*13*17, 13*17*19) == false
    @test coprime(2*3, 5*7) == true
end

function test_primes_eulerphi()
    @test eulerphi(1) == 1
    @test eulerphi(2) == 1
    @test eulerphi(3) == 2
    @test eulerphi(9) == 6
end

function test_primes_all()
    label = "Math.NumberTheory.Primes" * (fastprimes() ? "[fast]" : "[native]") * "..."
    print(rpad(label, 50, ' '))

    test_primes_factorization()
    test_primes_genprimes()
    test_primes_countprimes()
    test_primes_primepi()
    test_primes_nextprime()
    test_primes_prevprime()
    test_primes_nprimes()
    test_primes_nthprime()
    test_primes_someprimes()

    test_primes_twinprimes()
    test_primes_coprime()
    test_primes_eulerphi()

    println("PASS")
end
