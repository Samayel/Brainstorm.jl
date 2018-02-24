@reexport module _Algebra

import Base: sqrt, rand, log, zero, one, convert, colon
import Nemo: root, roots

export sqrts, elements, multiple

using Brainstorm._Algorithm: @forcartesian
using Brainstorm._Math: factor
using AbstractAlgebra: GroupElem
using Nemo: characteristic, degree, fmpz, FinFieldElem, FqFiniteField, FqNmodFiniteField, gen, isone, iszero, order, remove

convert(::Type{Integer}, n::fmpz) = BigInt(n)

colon(a::Integer, b::fmpz) = colon(fmpz(a), b)

include("group.jl")
include("field.jl")

end
