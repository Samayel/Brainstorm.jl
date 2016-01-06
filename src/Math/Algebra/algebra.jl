@reexport module Algebra

import Base: sqrt, rand, log, zero, one, convert, colon
import Nemo: root

export sqrts, roots

using Brainstorm.Math: factorization
using Nemo
using Nemo: FiniteFieldElem

const ZZ = fmpz

zero(::ZZ) = ZZ(0)
one(::ZZ) = ZZ(1)

convert(::Type{Integer}, n::ZZ) = BigInt(n)

colon(a::Integer, b::ZZ) = colon(ZZ(a), b)

include("group.jl")
include("field.jl")

end
