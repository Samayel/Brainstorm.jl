module Inplace

using Brainstorm.DataStructure: PreAllocatedStack
using Brainstorm.Math.GMP: set!, add!, mul!, div!, neg!, pow!, isqrt!

include("binarysplitting.jl")

const c3_over_24 = div(Int64(640320)^3, 24)
const digits_per_term = log10(c3_over_24 / (6 * 2 * 6))
const guard_terms = 5

preallocatedstack(size) = PreAllocatedStack(0, [(big(0), big(0), big(0)) for i in 1:size])

# Compute int(pi * 10^digits)
# This is done using Chudnovsky's series with binary splitting
pi(digits::Int64) = begin
    # how many terms to compute
    n = ceil(Int64, digits / digits_per_term) + guard_terms

    depth = 1
    while (1 << depth) <= n; depth += 1; end
    s = preallocatedstack(depth + 1)

    # calculate P(0, N), Q(0, N) and T(0, N)
    binarysplitting!(s, zero(n), n)
    p, q, t = s[1]

    sqrtC = p
    set!(sqrtC, 10)
    pow!(sqrtC, 2*UInt64(digits)) # one_squared
    mul!(sqrtC, 10005)
    isqrt!(sqrtC)

    mul!(q, 426880)
    mul!(q, sqrtC)
    div!(q, t)
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
compute!(s, a, b) = begin
    p, q, t = s[1]

    if a == 0
        set!(p, 1)
        set!(q, 1)
    else
        # p = (6a - 5) * (2a - 1) * (6a - 1)
        set!(p, 6*a - 5)
        mul!(p, 2*a - 1)
        mul!(p, 6*a - 1)

        # q = a^3 * c3_over_24
        set!(q, a)
        pow!(q, UInt(3))
        mul!(q, c3_over_24)
    end

    # t(a) = p(a) * a(a)
    # t = p * (13591409 + 545140134 * a)
    set!(t, a)
    mul!(t, 545140134)
    add!(t, 13591409)
    mul!(t, p)
    isodd(a) && neg!(t)
end

combine!(s) = begin
    p₁, q₁, t₁ = s[1]
    p₂, q₂, t₂ = s[2]

    # t = q₂ * t₁ + p₁ * t₂
    mul!(t₁, q₂)
    mul!(t₂, p₁)
    add!(t₁, t₂)

    # p = p₁ * p₂
    mul!(p₁, p₂)

    # q = q₁ * q₂
    mul!(q₁, q₂)
end

end
