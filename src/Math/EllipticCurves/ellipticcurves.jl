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

# ftp://ftp.cs.wisc.edu/pub/techreports/1988/TR795.pdf
sqrt(x::FiniteFieldElem) = begin
    F = parent(x)
    k = degree(F)
    q = order(F)

    if k == 1
        z = ZZ(coeff(x, 0))
        y = sqrtmod(z, q)
        return F(y)
    end

    P, p = PolynomialRing(F, "p")
    R = ResidueRing(P, p^2 - x)

    for i in 1:100
        y = rand(F)
        y^2 == x && return y

        z = R(p + y)^BigInt((q-1) ÷ 2)
        w = data(z)
 
        v = coeff(w, 0)
        v == 0 || continue

        u = coeff(w, 1)
        r = inv(u)
        r^2 == x && return r
    end

    error("no square root could be found")
end

# https://www.ma.utexas.edu/users/voloch/Preprints/roots.pdf
root(x::FiniteFieldElem, r::Integer) = begin
    F = parent(x)
    q = BigInt(characteristic(F))
    m = BigInt(degree(F))

    if gcd(q*(q-1), r) == 1
        k = 1
        qₖ = q % r
        while qₖ != 1
            k += 1
            k > r && error("no k with q^k = 1 (mod r), q=$q, r=$r could be found")
            qₖ = (qₖ * q) % r
        end
        gcd(m, k) == 1 || error("m=$m and k=$k are not coprime")

        qₘ = q^m - 1
        u = 1
        while u < r
            (u * qₘ + 1) % r == 0 && break
            u += 1
        end

        v = (q^m * u) ÷ r
    elseif (q-1) % r == 0
        gcd((q-1) ÷ r, r) == 1 || error("(q-1)÷r=$((q-1) ÷ r) and r=$r are not coprime")
        gcd(m, r) == 1 || error("m=$m and r=$r are not coprime")

        qₘ = (q^m - 1) ÷ r
        u = 1
        while u < r
            (u * qₘ + 1) % r == 0 && break
            u += 1
        end

        v, k = divrem(q^m * u, r^2)
        k > 0 && (v += 1)
    else
        error("root($(x), $(r)) is not supported in field '$(F)'")
    end

    y = x^v
    y^r == x || error("$(x) has no $(r)th roots in field '$(F)'")
    y
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
