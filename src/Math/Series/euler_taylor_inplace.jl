module Inplace

using Brainstorm.Algorithm: binarysearch
using Brainstorm.DataStructure: PreAllocatedStack
using Brainstorm.Math.GMP: set!, add!, mul!, div!, pow!

include("binarysplitting.jl")

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
    binarysplitting!(s, zero(n), n)
    p, q = s[1]
    o, _ = s[2]

    set!(o, 10)
    pow!(o, UInt64(digits)) # one

    mul!(p, o)
    div!(p, q)
    add!(p, o)
end

termfunc(k) = k * (ndigits(k) - 2)

compute!(s, a, b) = begin
    p, q = s[1]

    set!(p, 1)
    set!(q, b)
end

combine!(s) = begin
    p₁, q₁ = s[1]
    p₂, q₂ = s[2]

    # p = p₁ * q₂ + p₂
    mul!(p₁, q₂)
    add!(p₁, p₂)

    # q = q₁ * q₂
    mul!(q₁, q₂)
end

end
