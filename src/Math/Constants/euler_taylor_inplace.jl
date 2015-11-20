module Inplace

using Brainstorm.Algorithm: binarysearch
using Brainstorm.DataStructure: PreAllocatedStack
using Brainstorm.Math.GMP: set!, add!, mul!, div!, pow!

preallocatedstack(size) = PreAllocatedStack(0, [(big(0), big(0)) for i in 1:size])

# Compute int(e * 10^digits)
# This is done using Taylor series with binary splitting
euler(digits::Integer) = begin
    # How many terms to compute
    #
    # http://www.johndcook.com/blog/2011/06/10/stirling-approximation/
    #
    #             k! > 10^digits
    # =>      log k! > digits
    # => k log k - k > digits
    #
    # with log n! = sum_k=1^n log k
    #            >= int_x=1^n log x dx
    #             = n log n - n + 1
    #             > n log n - n
    #
    n = binarysearch(termfunc, digits + 1, one(digits), digits + 100)[2]

    depth = 1
    while (1 << depth) <= n; depth += 1; end
    s = preallocatedstack(depth + 1)

    # calculate P(0, N) and Q(0, N)
    binarysplitting(s, zero(n), n)
    p, q = s[1]
    o, _ = s[2]

    set!(o, 10)
    pow!(o, UInt64(digits)) # one

    mul!(p, o)
    div!(p, q)
    add!(p, o)
end

termfunc(k) = k * (ndigits(k) - 2)

# http://numbers.computation.free.fr/Constants/Algorithms/splitting.html
binarysplitting(s, a, b) = begin
    # directly compute P(a, a + 1) and Q(a, a + 1)
    (b - a) == 1 && (compute(s, a, b); return)

    # recursively compute P(a, b) and Q(a, b)

    # m is the midpoint of a and b
    m = (a + b) >> 1

    # recursively calculate P(a, m) and Q(a, m)
    binarysplitting(s, a, m)

    # recursively calculate P(m, b) and Q(m, b)
    push!(s)
    binarysplitting(s, m, b)
    pop!(s)

    # now combine
    combine(s)
end

compute(s, a, b) = begin
    p, q = s[1]

    set!(p, 1)
    set!(q, b)
end

combine(s) = begin
    p₁, q₁ = s[1]
    p₂, q₂ = s[2]

    # p = p₁ * q₂ + p₂
    mul!(p₁, q₂)
    add!(p₁, p₂)

    # q = q₁ * q₂
    mul!(q₁, q₂)
end

end
