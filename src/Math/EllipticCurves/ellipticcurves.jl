@reexport module EllipticCurves

# http://jeremykun.com/2014/02/08/introducing-elliptic-curves/
# http://jeremykun.com/2014/02/24/elliptic-curves-as-python-objects/
# http://jeremykun.com/2014/03/19/connecting-elliptic-curves-with-finite-fields-a-reprise/

using Reexport.@reexport

export curve, point, samecurve, ideal, ring, field, isideal

import Base: +, -, *, show, sqrt, rand, log
import Nemo: divexact, contains, order, gen, root

using AutoHashEquals
using Brainstorm.Math: factorization, factors
using Nemo
using Nemo: FiniteFieldElem

divexact(x::Number, y::Number) = x / y

sqrt(x::FiniteFieldElem) = root(x, 2)

root(x::FiniteFieldElem, n::Integer) = begin
    F = parent(x)
    P, p = PolynomialRing(F, "p")

    for (y, _) in factor(p^n - x)
        d = degree(y)
        c = coeff(y, d - 1)
        c^n == x && return c
    end

    error("$(x) has no $(n)th roots in field '$(F)'")
end

rand(F::Union{FqFiniteField,FqNmodFiniteField}) = begin
    p = characteristic(F)
    k = degree(F)
    g = gen(F)

    x = zero(F)
    for i in 0:k-1
        x += g^i * rand(0:convert(BigInt, p-1))
    end
    x
end

include("curve.jl")
include("point.jl")
include("group.jl")

end
