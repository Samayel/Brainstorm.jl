using Brainstorm: takewhile, Functor
using Pipe.@pipe

export
    factorization,
    genprimes, countprimes, primepi,
    nextprime, prevprime,
    nprimes, nthprime,
    allprimes, someprimes

factorization(n::Integer) = Base.factor(n)

##  Eratosthenes' prime number sieve
# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
primesieve{T<:Integer}(n::T) = begin
    n <= 1 && return T[]

    p = collect(one(T):convert(T, 2):n)
    q = length(p)
    p[1] = convert(T, 2)

    if n >= 9
        for k = 3:2:isqrt(n)
            if p[(k+1)>>1] != 0
                p[(k*k+1)>>1:k:q] = zero(T)
            end
        end
    end

    p[p .> 0]
end

##  Find all prime numbers in  a given interval
# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
primesieve(n::Integer, m::Integer) = primesieve(promote(n, m)...)
primesieve{T<:Integer}(n::T, m::T) = begin
    n > m && error("Argument 'm' must not be less than 'n'.")
    n = max(n, 1)
    m = max(m, 1)

    if m <= 1000
        P = primesieve(m)
        return P[P .>= n]
    end

    myPrimes = primesieve(isqrt(m))
    N = collect(n:m)
    l = length(N)  # m-n+1
    A = zeros(Int8, l)
    if n == 1
        A[1] = -1
    end

    for p in myPrimes
        r = n % p
        i = r == 0 ? 1 : p - r + 1

        if i <= l && N[i] == p
            i = i + p
        end

        while i <= l
            A[i] = 1
            i = i + p
        end
    end
    N[A .== 0]
end

genprimes(a::Integer, b::Integer) = primesieve(a, b)
genprimes(b::Integer) = primesieve(b)

countprimes(a::Integer, b::Integer) = countprimes(promote(a, b)...)
countprimes{T<:Integer}(a::T, b::T) = @pipe Base.primesmask(b) |> count(TrueAndIdxGeq(a), _)
primepi(n::Integer) = countprimes(2, n)

immutable TrueAndIdxGeq{T} <: Base.Func{2}
    minidx::T
end
Base.call(f::TrueAndIdxGeq, i, x) = x && (i >= f.minidx)

nprimes(n::Integer) = primesieve(ceil(Integer, n*log(n+2) + n*log(log(n+2))))[1:n]
nprimes(n::Integer, start::Integer) = @pipe allprimes(start) |> take(_, n) |> collect
nthprime(n::Integer) = nprimes(n)[n]

# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
nextprime{T<:Integer}(n::T) = begin
    n <= 1 && return convert(T, 2)
    n == 2 && return convert(T, 3)

    n += iseven(n) ? one(T) : convert(T, 2)
    isprime(n) && return n

    m = mod(n, 3)
    if m == 1
        a = convert(T, 4); b = convert(T, 2)
    elseif m == 2
        a = convert(T, 2); b = convert(T, 4)
    else
        n += 2
        a = convert(T, 2); b = convert(T, 4)
    end

    p = n
    while !isprime(p)
        p += a
        isprime(p) && break
        p += b
    end
    p
end

# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
prevprime{T<:Integer}(n::T) = begin
    n <= 2 && throw(DomainError())
    n == 3 && return convert(T, 2)

    n -= iseven(n) ? one(T) : convert(T, 2)
    isprime(n) && return n

    m = mod(n, 3)
    if m == 1
        a = convert(T, 2); b = convert(T, 4)
    elseif m == 2
        a = convert(T, 4); b = convert(T, 2)
    else
        n -= 2
        a = convert(T, 2); b = convert(T, 4)
    end

    p = n
    while !isprime(p)
        p -= a
        isprime(p) && break
        p -= b
    end
    p
end

allprimes(n::Integer = 2) = PrimeIterator(n)

someprimes(n1::Integer, n2::Integer) = someprimes(promote(n1, n2)...)
someprimes{T<:Integer}(n1::T, n2::T) = @pipe allprimes(n1) |> takewhile(Functor.leq(n2), _)
someprimes(n2::Integer) = someprimes(2, n2)

type PrimeIterator{T<:Integer}
    n::T
end

Base.start(it::PrimeIterator) = nextprime(it.n - one(it.n))
Base.next(::PrimeIterator, state) = state, nextprime(state)
Base.done(::PrimeIterator, _) = false
Base.eltype(it::PrimeIterator) = Base.eltype(typeof(it))
Base.eltype{T}(::Type{PrimeIterator{T}}) = T

# testf is not a function and uses two parameters
function count(testf, coll)
    c = 0
    for (i, a) in enumerate(coll)
        c += testf(i, a)
    end
    c
end
