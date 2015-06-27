module Primes

using Brainstorm.Math.NumberTheory.Primes
using Brainstorm: dropwhile
using Base.Test
using Compat

function test_factorization()
    @test factorization(147573952589676412927) ==
        @compat Dict{Int, Int}(193707721 => 1, 761838257287 => 1)
    @test factorization((big(2)^31-1)*(big(2)^17-1)) ==
        @compat Dict(big(2^31-1) => 1, big(2^17-1) => 1)
end

function test_genprimes()
    @test genprimes(10) == [2, 3, 5, 7]
    @test genprimes(11) == [2, 3, 5, 7, 11]
    @test genprimes(10, 20) == [11, 13, 17, 19]
    @test genprimes(11, 19) == [11, 13, 17, 19]
    @test genprimes(1000, 1100) == [1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097]
    @test genprimes(10^6) == Base.primes(10^6)
    @test eltype(genprimes(10)) == typeof(2)
    @test eltype(genprimes(10, 20)) == typeof(11)
end

function test_countprimes()
    @test countprimes(10, 20) == 4
    @test countprimes(11, 19) == 4
end

function test_primepi()
    @test primepi(10) == 4
    @test primepi(11) == 5
    @test primepi(10000) == 1229
end

function test_nextprime()
    @test [nextprime(i) for i = -1:100] ==
        [first(dropwhile(p -> p <= i, Base.PRIMES)) for i = -1:100]
end

function test_prevprime()
    @test_throws DomainError prevprime(-1)
    @test_throws DomainError prevprime(0)
    @test_throws DomainError prevprime(1)
    @test_throws DomainError prevprime(2)
    @test [prevprime(i) for i = 3:100] ==
        [first(dropwhile(p -> p >= i, reverse(Base.PRIMES))) for i = 3:100]
end

function test_nprimes()
    @test nprimes(10) == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    @test nprimes(10, 100) == [101, 103, 107, 109, 113, 127, 131, 137, 139, 149]
    @test eltype(nprimes(10)) == typeof(2)
    @test eltype(nprimes(10, 100)) == typeof(101)
end

function test_nthprime()
    @test nthprime(1000) == 7919
end

function test_someprimes()
    @test collect(someprimes(10)) == [2, 3, 5, 7]
    @test collect(someprimes(11)) == [2, 3, 5, 7, 11]
    @test collect(someprimes(10, 20)) == [11, 13, 17, 19]
    @test collect(someprimes(11, 19)) == [11, 13, 17, 19]
    @test eltype(someprimes(10)) == typeof(2)
    @test eltype(someprimes(10, 20)) == typeof(11)
end

function test_all()
    print(rpad("Math.NumberTheory.Primes...", 50, ' '))

    test_factorization()
    test_genprimes()
    test_countprimes()
    test_primepi()
    test_nextprime()
    test_prevprime()
    test_nprimes()
    test_nthprime()
    test_someprimes()

    println("PASS")
end

end
