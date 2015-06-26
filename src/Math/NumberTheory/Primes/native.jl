using Brainstorm: takewhile, @anon
using Pipe.@pipe

export
    factorization,
    genprimes, countprimes, primepi,
    nextprime, prevprime,
    nprimes, nthprime,
    allprimes, someprimes

factorization(n::Integer) = Base.factor(n)

genprimes(a::Integer, b::Integer) = genprimes(promote(a, b)...)
genprimes{T<:Integer}(a::T, b::T) = @pipe Base.primesmask(b) |> find((i, x) -> x && (i >= a), _)
genprimes(b::Integer) = Base.primes(b)

countprimes(a::Integer, b::Integer) = countprimes(promote(a, b)...)
countprimes{T<:Integer}(a::T, b::T) = @pipe Base.primesmask(b) |> count((i, x) -> x && (i >= a), _)
primepi(n::Integer) = countprimes(2, n)

nprimes(n::Integer) = Base.primes(ceil(Integer, n*log(n+2) + n*log(log(n+2))))[1:n]
nprimes(n::Integer, start::Integer) = @pipe allprimes(start) |> take(_, n) |> collect
nthprime(n::Integer) = nprimes(n)[n]

# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
nextprime(n::Integer) = begin
    n <= 1 && return 2
    n == 2 && return 3

    n += iseven(n) ? 1 : 2
    isprime(n) && return n

    m = mod(n, 3)
    if m == 1
        a = 4; b = 2
    elseif m == 2
        a = 2; b = 4
    else
        n += 2
        a = 2; b = 4
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
prevprime(n::Integer) = begin
    n <= 2 && throw(DomainError())
    n == 3 && return 2

    n -= iseven(n) ? 1 : 2
    isprime(n) && return n

    m = mod(n, 3)
    if m == 1
        a = 2; b = 4
    elseif m == 2
        a = 4; b = 2
    else
        n -= 2
        a = 2; b = 4
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
someprimes{T<:Integer}(n1::T, n2::T) = @pipe allprimes(n1) |> takewhile(@anon(x -> x <= n2), _)
someprimes(n2::Integer) = someprimes(2, n2)

type PrimeIterator{T<:Integer}
    n::T
end

Base.start(it::PrimeIterator) = nextprime(it.n - one(it.n))
Base.next(::PrimeIterator, state) = state, nextprime(state)
Base.done(::PrimeIterator, _) = false
Base.eltype(it::PrimeIterator) = Base.eltype(typeof(it))
Base.eltype{T}(::Type{PrimeIterator{T}}) = T

function find(testf::Function, A::AbstractArray)
    # use a dynamic-length array to store the indexes,
    # then copy to a non-padded array for the return
    tmpI = Array(Int, 0)
    for i = 1:length(A)
        if testf(i, A[i])
            push!(tmpI, i)
        end
    end
    ansI = Array(Int, length(tmpI))
    copy!(ansI, tmpI)
    ansI
end

function count(testf::Function, A::AbstractArray)
    c = 0
    for i = 1:length(A)
        if testf(i, A[i])
            c += 1
        end
    end
    c
end
