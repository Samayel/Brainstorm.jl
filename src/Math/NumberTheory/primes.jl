export
    isprime, ismersenneprime, isrieselprime,
    primes, primesmask,
    nextprime, prevprime, prime,
    factor, prodfactors,
    radical, totient,
    coprime

Primes.isprime(n::Integer, mask) = n <= length(mask) ? mask[n] : isprime(n)

##  Coprimality
# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
coprime(n::T, m::T) where {T<:Integer} = begin
    n == 0 && m == 0 && return false
    gcd(n, m) == 1
end
