export
    factorization

const FACTORIZATION_THRESHOLD = typemax(Int32)

factorization(n::Integer) = n < FACTORIZATION_THRESHOLD ?
    Base.factor(n) :
    mfactor(n)

Base.eltype(it::PrimeSieve.PrimeInfIt) = Base.eltype(typeof(it))
Base.eltype(it::PrimeSieve.PrimeIt) = Base.eltype(typeof(it))
Base.eltype{T}(::Type{PrimeSieve.PrimeInfIt{T}}) = T
Base.eltype{T}(::Type{PrimeSieve.PrimeIt{T}}) = T
