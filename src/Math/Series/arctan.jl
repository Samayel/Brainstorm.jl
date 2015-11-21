module Arctan

using Brainstorm.DataStructure: PreAllocatedStack
using Brainstorm.Math.GMP: set!, add!, mul!, div!

const guard_terms = 5

preallocatedstack(size) = PreAllocatedStack(0, [(big(0), big(0), big(0)) for i in 1:size])

arctan(digits::Integer, reciprocal_x::Integer) = begin
    p, q = _arctan(digits, reciprocal_x, false)
    o = big(10)^digits # one

    mul!(p, o)
    div!(p, q)
end

arctanh(digits::Integer, reciprocal_x::Integer) = begin
    p, q = _arctan(digits, reciprocal_x, true)
    o = big(10)^digits # one

    mul!(p, o)
    div!(p, q)
end

# http://numbers.computation.free.fr/Constants/Log2/log2.html
_arctan{T<:Integer}(digits::T, reciprocal_x::Integer, hyperbolic) = begin
    # How many terms to compute
    #
    #         x^(2k+1) > 10^digits
    # => (2k+1) log(x) > digits * log(10)
    # =>        2k + 1 > digits * log(10) / log(x)
    # =>            2k > digits * log(10) / log(x)
    # =>             k > [digits * log(10) / log(x)] / 2
    #
    n = trunc(T, (digits / 2) * log(reciprocal_x, 10) + guard_terms)

    depth = 1
    while (1 << depth) <= n; depth += 1; end
    s = preallocatedstack(depth + 1)

    # calculate P(0, N), Q(0, N) and T(0, N)
    binarysplitting!(s, reciprocal_x^2, hyperbolic, zero(n), n)
    p, q, _ = s[1]

    add!(p, q)
    mul!(q, reciprocal_x)

    p, q
end

binarysplitting!(s, sqrx, hyperbolic, a, b) = begin
    # directly compute P(a, a + 1), Q(a, a + 1) and T(a, a + 1)
    (b - a) == 1 && (compute!(s, sqrx, hyperbolic, a, b); return)

    # recursively compute P(a, b), Q(a, b) and T(a, b)

    # m is the midpoint of a and b
    m = (a + b) >> 1

    # recursively calculate P(a, m), Q(a, m) and T(a, m)
    binarysplitting!(s, sqrx, hyperbolic, a, m)

    # recursively calculate P(m, b), Q(m, b) and T(m, b)
    push!(s)
    binarysplitting!(s, sqrx, hyperbolic, m, b)
    pop!(s)

    # now combine
    combine!(s)
    return
end

compute!(s, sqrx, hyperbolic, a, b) = begin
    p, q, t = s[1]

    y = 2a + 3

    set!(p, hyperbolic || isodd(a) ? 1 : -1)
    set!(q, y)
    mul!(q, sqrx)
    set!(t, y)
end

combine!(s) = begin
    p₁, q₁, t₁ = s[1]
    p₂, q₂, t₂ = s[2]

    # p = q₂ * p₁ + t₁ * p₂
    mul!(p₁, q₂)
    mul!(p₂, t₁)
    add!(p₁, p₂)

    # q = q₁ * q₂
    mul!(q₁, q₂)

    # t = t₁ * t₂
    mul!(t₁, t₂)
end

end
