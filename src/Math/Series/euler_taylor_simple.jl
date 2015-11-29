module Simple

using Brainstorm.Algorithm: binarysearch

include("binarysplitting.jl")

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

    # calculate P(0, N) and Q(0, N)
    p, q = binarysplitting(zero(n), n)

    o = big(10)^digits # one
    o + (o * p) ÷ q
end

termfunc(k) = k * (ndigits(k) - 2)

compute(a, b) = big(1), big(b)

combine(am, mb) = begin
    p₁, q₁ = am
    p₂, q₂ = mb

    p = p₁ * q₂ + p₂
    q = q₁ * q₂

    p, q
end

end
