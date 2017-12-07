export
    isprime, ismersenneprime, isrieselprime,
    primes, primesmask,
    nextprime, prevprime, prime,
    coprime

Nemo.isprime(n::UInt) = is_prime(n)
Nemo.isprime(n::Integer) = typemin(UInt) <= n <= typemax(UInt) ? (isprime ∘ UInt)(n) : (isprime ∘ fmpz)(n)
Nemo.isprime(n::Integer, mask) = n <= length(mask) ? mask[n] : isprime(n)

coprime(n::Integer, m::Integer) = n != 0 && m != 0 && gcd(n, m) == 1
