module Arctan

using Brainstorm.DataStructure: PreAllocatedStack
using Brainstorm.Math.GMP: set!, add!, mul!, div!, pow!

const guard_terms = 5
const guard_digits = 5

preallocatedstack(size) = PreAllocatedStack(0, [(big(0), big(0), big(0)) for i in 1:size])

arctan(digits::Integer, reciprocal_x::Integer) = begin
    p, q, o = _arctan(digits, false, reciprocal_x)

    set!(o, 10)
    pow!(o, digits) # one

    mul!(p, o)
    div!(p, q)
end

arctanh(digits::Integer, reciprocal_x::Integer) = begin
    p, q, o = _arctan(digits, true, reciprocal_x)

    set!(o, 10)
    pow!(o, digits) # one

    mul!(p, o)
    div!(p, q)
end

arctansum(digits::Integer, rx, coeff) = begin
    p, q, o = _arctansum(digits, false, rx, coeff)

    set!(o, 10)
    pow!(o, digits) # one

    mul!(p, o)
    div!(p, q)
end

arctanhsum(digits::Integer, rx, coeff) = begin
    p, q, o = _arctansum(digits, true, rx, coeff)

    set!(o, 10)
    pow!(o, digits) # one

    mul!(p, o)
    div!(p, q)
end

_arctan(digits, hyperbolic, rx) = begin
    n = terms(digits, rx)

    depth = 1
    while (1 << depth) <= n; depth += 1; end
    s = preallocatedstack(depth + 1)

    _arctan(hyperbolic, rx, n, s)
end

_arctansum(digits, hyperbolic, rx, f) = begin
    n = [terms(digits + guard_digits, x) for x in rx]

    depth = 1
    maxn = maximum(n)
    while (1 << depth) <= maxn; depth += 1; end
    s = preallocatedstack(depth + 2)

    for i in 1:length(rx)
        p, q, _ = _arctan(hyperbolic, rx[i], n[i], s)
        f[i] != 1 && mul!(p, f[i])

        if i > 1
            pop!(s)
            sp, sq = s[1]

            # sp = sp * q + p * sq
            mul!(p, sq)
            mul!(sp, q)
            add!(sp, p)

            # sq = sq * q
            mul!(sq, q)
        end
        push!(s)
    end
    pop!(s)

    p, q, t = s[1]
    p, q, t
end

# How many terms to compute
#
#         x^(2k+1) > 10^digits
# => (2k+1) log(x) > digits * log(10)
# =>        2k + 1 > digits * log(10) / log(x)
# =>            2k > digits * log(10) / log(x)
# =>             k > [digits * log(10) / log(x)] / 2
#
terms{T<:Integer}(digits::T, rx) = trunc(T, (digits / 2) * log(rx, 10) + guard_terms)

_arctan(hyperbolic, rx, n, s) = begin
    # calculate P(0, N), Q(0, N) and T(0, N)
    binarysplitting!(s, hyperbolic, rx^2, zero(n), n)

    complete!(s, rx)
end

binarysplitting!(s, hyperbolic, sqrx, a, b) = begin
    # directly compute P(a, a + 1), Q(a, a + 1) and T(a, a + 1)
    (b - a) == 1 && (compute!(s, hyperbolic, sqrx, a, b); return)

    # recursively compute P(a, b), Q(a, b) and T(a, b)

    # m is the midpoint of a and b
    m = (a + b) >>> 1

    # recursively calculate P(a, m), Q(a, m) and T(a, m)
    binarysplitting!(s, hyperbolic, sqrx, a, m)

    # recursively calculate P(m, b), Q(m, b) and T(m, b)
    push!(s)
    binarysplitting!(s, hyperbolic, sqrx, m, b)
    pop!(s)

    # now combine
    combine!(s)
    return
end

compute!(s, hyperbolic, sqrx, a, b) = begin
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

complete!(s, rx) = begin
    p, q, t = s[1]

    add!(p, q)
    mul!(q, rx)

    p, q, t
end

end
