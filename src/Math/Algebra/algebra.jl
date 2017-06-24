@reexport module _Algebra

import Base: sqrt, rand, log, zero, one, convert, colon
import Nemo: root, roots

export sqrts, elements, multiple

using Brainstorm._Algorithm: @forcartesian
using Brainstorm._Math: factorization
using Nemo: characteristic, degree, fmpz, FinFieldElem, FqFiniteField, FqNmodFiniteField, gen, GroupElem, isone, iszero, order, remove

convert(::Type{Integer}, n::fmpz) = BigInt(n)

colon(a::Integer, b::fmpz) = colon(fmpz(a), b)

include("group.jl")
include("field.jl")

end
