export
    isprime, iscoprime, ismersenneprime, isrieselprime,
    primes, primesmask, primepi,
    nthprime, nextprime, prevprime,
    twinprimes

Nemo.isprime(n::UInt) = is_prime(n)
Nemo.isprime(n::Integer) = typemin(UInt) <= n <= typemax(UInt) ? (isprime ∘ UInt)(n) : (isprime ∘ fmpz)(n)
Nemo.isprime(n::Integer, mask) = n <= length(mask) ? mask[n] : isprime(n)

iscoprime(n::Integer, m::Integer) = n != 0 && m != 0 && gcd(n, m) == 1

Primes.primes(r::UnitRange{<:Integer}) = primes(first(r), last(r))

Primes.primesmask(r::UnitRange{<:Integer}) = primesmask(first(r), last(r))

primepi(a::Integer, b::Integer) = (count ∘ primesmask)(a, b)
primepi(r::UnitRange{<:Integer}) = primepi(first(r), last(r))
primepi(n::Integer) = primepi(1, n)

nthprime(a::Integer, b::Integer) = (n = ceil(typeof(b), b*log(b+2) + b*(log∘log)(b+2)); primes(n)[a:b])
nthprime(r::UnitRange{<:Integer}) = nthprime(first(r), last(r))
nthprime(n::Integer) = nthprime(n, n)[1]

# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
nextprime(n::T) where {T<:Integer} = begin
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
prevprime(n::T) where {T<:Integer} = begin
    n <= 2 && return zero(T)
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

##  Find all twin primes
# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
twinprimes(a::Integer, b::Integer) = begin
    P = primes(a, b)
    inds = find(diff(P) .== 2)
    hcat(P[inds], P[inds+1])
end
twinprimes(r::UnitRange{<:Integer}) = twinprimes(first(r), last(r))
