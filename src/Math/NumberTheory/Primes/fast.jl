export factorization

const FACTORIZATION_THRESHOLD = typemax(Int32)

factorization(n::Integer) = n < FACTORIZATION_THRESHOLD ?
    Primes.factor(n) :
    mfactor(n)

Base.eltype(it::PrimeSieve.PrimeInfIt) = Base.eltype(typeof(it))
Base.eltype(it::PrimeSieve.PrimeIt) = Base.eltype(typeof(it))
Base.eltype(::Type{PrimeSieve.PrimeInfIt{T}}) where {T} = T
Base.eltype(::Type{PrimeSieve.PrimeIt{T}}) where {T} = T
