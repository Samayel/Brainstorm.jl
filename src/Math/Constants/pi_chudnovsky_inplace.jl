module Inplace

using Brainstorm.Math: add!, mul!, neg!, pow!

const c3_over_24 = div(Int64(640320)^3, 24)
const digits_per_term = log10(c3_over_24 / (6 * 2 * 6))
const guard_terms = 5

# Compute int(pi * 10^digits)
# This is done using Chudnovsky's series with binary splitting
pi{T<:Integer}(digits::T) = begin
    # how many terms to compute
    n = ceil(T, digits / digits_per_term) + guard_terms

    # calculate P(0, N), Q(0, N) and T(0, N)
    p, q, t = binarysplitting(zero(n), n)

    one_squared = big(10)^(2*digits)
    sqrtC = isqrt(10005 * one_squared)

    div(q * 426880 * sqrtC, t)
end

# http://numbers.computation.free.fr/Constants/Algorithms/splitting.html
binarysplitting(a, b) = begin
    # directly compute P(a, a + 1), Q(a, a + 1) and T(a, a + 1)
    (b - a) == 1 && return compute(a, b)

    # recursively compute P(a, b), Q(a, b) and T(a, b)

    # m is the midpoint of a and b
    m = (a + b) >> 1 

    # recursively calculate P(a, m), Q(a, m) and T(a, m)
    p₁, q₁, t₁ = binarysplitting(a, m)
    # recursively calculate P(m, b), Q(m, b) and T(m, b)
    p₂, q₂, t₂ = binarysplitting(m, b)

    # now combine

    # t = q₂ * t₁ + p₁ * t₂
    mul!(t₁, q₂)
    mul!(t₂, p₁)
    add!(t₁, t₂)

    # p = p₁ * p₂
    mul!(p₁, p₂)

    # q = q₁ * q₂
    mul!(q₁, q₂)

    p₁, q₁, t₁
end

#
# Source: http://www.craig-wood.com/nick/articles/pi-chudnovsky/
#
# Computes the terms for binary splitting the Chudnovsky infinite series
#
# a(a) = +/- (13591409 + 545140134*a)
# p(a) = (6*a-5)*(2*a-1)*(6*a-1)
# b(a) = 1
# q(a) = a*a*a*C3_OVER_24
#
compute(a, b) = begin
    if a == 0
        p, q = big(1), big(1)
    else
        # q = a^3 * c3_over_24
        q = big(a)
        pow!(q, UInt(3))
        mul!(q, c3_over_24)

        # p = (6a - 5) * (2a - 1) * (6a - 1)
        p = big(6*a - 5)
        mul!(p, 2*a - 1)
        mul!(p, 6*a - 1)
    end

    # t(a) = p(a) * a(a)
    # t = p * (13591409 + 545140134 * a)
    t = big(a)
    mul!(t, 545140134)
    add!(t, 13591409)
    mul!(t, p)
    # isodd(a) && (t = -t)
    isodd(a) && neg!(t)

    p, q, t
end

end
