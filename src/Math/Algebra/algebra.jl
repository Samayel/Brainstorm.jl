@reexport module Algebra

import Base: call, sqrt, rand, log, zero, one, convert, colon
import Nemo: root

export sqrts, roots, elements, multiple

using Base: AddFun, MulFun
using Brainstorm.Algorithm: @forcartesian
using Brainstorm.Math: factorization
using Brainstorm.Meta.Functor: NegFun, InvFun
using Nemo
using Nemo: FinFieldElem

const ZZ = fmpz

convert(::Type{Integer}, n::ZZ) = BigInt(n)

colon(a::Integer, b::ZZ) = colon(ZZ(a), b)

include("group.jl")
include("field.jl")

end
