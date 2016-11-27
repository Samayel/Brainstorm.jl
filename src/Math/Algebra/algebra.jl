@reexport module Algebra

import Base: call, sqrt, rand, log, zero, one, convert, colon
import Nemo: root

export sqrts, roots, elements, multiple

using Brainstorm.Algorithm: @forcartesian
using Brainstorm.Math: factorization
using Nemo
using Nemo: FinFieldElem

const ZZ = fmpz

convert(::Type{Integer}, n::ZZ) = BigInt(n)

colon(a::Integer, b::ZZ) = colon(ZZ(a), b)

include("group.jl")
include("field.jl")

end
