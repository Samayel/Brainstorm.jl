module Simple

include("binarysplitting.jl")

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
compute(a, b) = compute(convert(BigInt, a), convert(BigInt, b))
compute(a::BigInt, b::BigInt) = begin
    if a == 0
        p = q = big(1)
    else
        a2 = a * 2
        a6 = a2 * 3
        p = (a6 - 5) * (a2 - 1) * (a6 - 1)
        q = a^3 * c3_over_24
    end

    # t(a) = p(a) * a(a)
    t = p * (13591409 + 545140134 * a)
    isodd(a) && (t = -t)

    p, q, t
end

combine(am, mb) = begin
    p₁, q₁, t₁ = am
    p₂, q₂, t₂ = mb

    p = p₁ * p₂
    q = q₁ * q₂
    t = q₂ * t₁ + p₁ * t₂

    p, q, t
end

end
