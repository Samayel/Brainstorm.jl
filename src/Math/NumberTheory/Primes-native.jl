using Brainstorm.DataStructure: takewhile
using Pipe.@pipe

export
    yfactor,
    genprimes, countprimes, primepi,
    nextprime, prevprime,
    nprimes, nthprime,
    allprimes, someprimes

yfactor(n::Integer) = Base.factor(n)

genprimes(a::Integer, b::Integer) = genprimes(promote(a, b)...)
genprimes{T<:Integer}(a::T, b::T) = @pipe Base.primesmask(b) |> find((i, x) -> x && (i >= a), _)
genprimes(b::Integer) = Base.primes(b)

countprimes(a::Integer, b::Integer) = countprimes(promote(a, b)...)
countprimes{T<:Integer}(a::T, b::T) = @pipe Base.primesmask(b) |> count((i, x) -> x && (i >= a), _)
primepi(n::Integer) = countprimes(2, n)

nprimes(n::Integer) = Base.primes(ceil(Integer, n*log(n+2) + n*log(log(n+2))))[1:n]
nprimes(n::Integer, start::Integer) = @pipe allprimes(start) |> take(_, n) |> collect
nthprime(n::Integer) = nprimes(n)[n]


nextprime(n::Integer) = begin
    p = n + one(n)
    while !isprime(p)
        p += one(n)
    end
    p
end
prevprime(n::Integer) = begin
    n <= 2 && throw(DomainError())

    p = n - one(n)
    while !isprime(p)
        p -= one(n)
    end
    p
end

allprimes(n::Integer = 2) = PrimeIterator(n)

someprimes(n1::Integer, n2::Integer) = someprimes(promote(n1, n2)...)
someprimes{T<:Integer}(n1::T, n2::T) = @pipe allprimes(n1) |> takewhile(_, x -> x <= n2)
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
