
module NewPrimes

primesmask(n::Integer) = begin
    sieve = trues(n)
    sieve[1] = false

    @inbounds for p in 2:isqrt(n)
        if sieve[p]
            for i in p*p:p:n
                sieve[i] = false
            end
        end
    end

    sieve
end

primes(n::Integer) = primes(one(n), n)
primes(a::Integer, b::Integer) = primes(promote(a, b)...)
primes(a::T, b::T) where {T<:Integer} = begin
    maskedprimes = primesmask(max(isqrt(b), 2))
    PrimeSieveIterator(a, b, maskedprimes)
end



mutable struct PrimeSieveSegment{T<:Integer}
    sieve::BitVector
    offset::T
end

@inline isprime(segment::PrimeSieveSegment, n::Integer) = segment.sieve[n - segment.offset]

@inline last(segment::PrimeSieveSegment) = length(segment.sieve) + segment.offset

@inline shift!(segment::PrimeSieveSegment) = (segment.offset += length(segment.sieve))

sieve!(segment::PrimeSieveSegment, maskedprimes::AbstractArray{Bool}) = sieve!(segment.sieve, segment.offset, maskedprimes)

sieve!(sieve::AbstractArray{Bool}, offset::Integer, maskedprimes::AbstractArray{Bool}) = begin # starts sieving at segment.offset + 1
    offset >= length(maskedprimes) || error("Argument 'offset' must be an integer greater than or equal to length(maskedprimes)")
    sieve .= true

    lastfactor = min(isqrt(length(sieve) + offset), length(maskedprimes))
    @inbounds for p in 2:lastfactor
        if maskedprimes[p]
            for i in (p - offset%p):p:length(sieve)
                sieve[i] = false
            end
        end
    end
end

nextprime!(segment::PrimeSieveSegment, lowerbound::Integer, upperbound::Integer, maskedprimes::AbstractArray{Bool}) = begin
    nextprime = lowerbound
    segmentlast = last(segment)

    while nextprime <= upperbound
        while nextprime > segmentlast
            shift!(segment)
            sieve!(segment, maskedprimes)
            segmentlast = last(segment)
        end

        isprime(segment, nextprime) && break
        nextprime += one(nextprime)
    end

    nextprime
end



immutable PrimeSieveIterator{T<:Integer}
    first::T
    last::T
    maskedprimes::BitVector
end

Base.start(s::PrimeSieveIterator{T}) where {T<:Integer} = begin
    segment = PrimeSieveSegment(copy(s.maskedprimes), zero(T))
    nextprime = nextprime!(segment, s.first, s.last, s.maskedprimes)
    (segment, nextprime)
end

Base.next(s::PrimeSieveIterator, state) = begin
    segment, lastprime = state
    nextprime = nextprime!(segment, lastprime + one(lastprime), s.last, s.maskedprimes)
    (lastprime, (segment, nextprime))
end

Base.done(s::PrimeSieveIterator, state) = begin
    _, lastprime = state
    lastprime > s.last
end

Base.eltype(it::PrimeSieveIterator) = Base.eltype(typeof(it))
Base.eltype(::Type{PrimeSieveIterator{T}}) where {T} = T

Base.iteratorsize(::PrimeSieveIterator) = Base.SizeUnknown()

end


using Brainstorm: isprime
using Base.Test

for n in 1:1_000
    mask = NewPrimes.primesmask(n)
    @test typeof(mask) == BitVector
    @test length(mask) == n
    for i in 1:n
        @test mask[i] == isprime(i)
    end
end

for n in big(1):big(100)
    mask = NewPrimes.primesmask(n)
    @test typeof(mask) == BitVector
    @test length(mask) == n
    for i in 1:n
        @test mask[i] == isprime(i)
    end
end



for n in 1:1_000
    iterator = NewPrimes.primes(n)
    @test collect(iterator) == [i for i in 1:n if isprime(i)]
    @test eltype(iterator) == Int
end

for n in big(1):big(100)
    iterator = NewPrimes.primes(n)
    @test collect(iterator) == [i for i in 1:n if isprime(i)]
    @test eltype(iterator) == BigInt
end

for a in 1:100
    for b in a:200
        iterator = NewPrimes.primes(a, b)
        @test collect(iterator) == [i for i in a:b if isprime(i)]
        @test eltype(iterator) == Int
    end
end

iterator = NewPrimes.primes(10_000_000, 10_001_000)
@test collect(iterator) == [i for i in 10_000_000:10_001_000 if isprime(i)]
@test eltype(iterator) == Int



segment = falses(100)
NewPrimes.sieve!(segment, 0, Bool[])
@test segment == trues(100)

segment = falses(100)
@test_throws ErrorException NewPrimes.sieve!(segment, 0, Bool[false])

segment = falses(100)
NewPrimes.sieve!(segment, 3, [false, true, true])
@test segment == [i%2 != 0 && i%3 != 0 for i in 4:103]
