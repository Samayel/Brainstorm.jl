fastprimes() = true

mfactor{T<:Integer}(n::T) = PrimeSieve.mfactor(n)

nprimes{T<:Integer}(n::T) = PrimeSieve.nprimes(n, 1)
nthprime{T<:Integer}(n::T) = PrimeSieve.nthprime(n)
