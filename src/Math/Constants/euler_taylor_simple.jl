module Simple

using Brainstorm.Algorithm: binarysearch

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
    o + div(o * p, q)
end

termfunc(k) = k * (ndigits(k) - 2)

# http://numbers.computation.free.fr/Constants/Algorithms/splitting.html
binarysplitting(a, b) = begin
    # directly compute P(a, a + 1) and Q(a, a + 1)
    (b - a) == 1 && return compute(a, b)

    # recursively compute P(a, b) and Q(a, b)

    # m is the midpoint of a and b
    m = div(a + b, 2)

    # recursively calculate P(a, m) and Q(a, m)
    am = binarysplitting(a, m)
    # recursively calculate P(m, b) and Q(m, b)
    mb = binarysplitting(m, b)

    # now combine
    combine(am, mb)
end

compute(a, b) = big(1), big(b)

combine(am, mb) = begin
    p₁, q₁ = am
    p₂, q₂ = mb

    p = p₁ * q₂ + p₂
    q = q₁ * q₂

    p, q
end

end
