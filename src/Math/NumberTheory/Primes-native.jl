fastprimes() = false

mfactor(n::Integer) = factor(n)

nprimes(n::Integer) = primes(ceil(Integer, n*log(n+2) + n*log(log(n+2))))[1:n]
nthprime(n::Integer) = nprimes(n)[n]
