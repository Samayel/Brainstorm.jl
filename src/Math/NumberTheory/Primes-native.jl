fastprimes() = false

mfactor{T<:Integer}(n::T) = factor(n)

nprimes{T<:Integer}(n::T) = primes(ceil(Integer, n*log(n+2) + n*log(log(n+2))))[1:n]
nthprime{T<:Integer}(n::T) = nprimes(n)[n]
