export
    isprime, ismersenneprime, isrieselprime,
    primes, primesmask,
    nextprime, prevprime, prime,
    coprime

Primes.isprime(n::Integer, mask) = n <= length(mask) ? mask[n] : isprime(n)

coprime(n::Integer, m::Integer) = n != 0 && m != 0 && gcd(n, m) == 1
