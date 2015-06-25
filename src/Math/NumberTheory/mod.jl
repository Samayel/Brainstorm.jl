export
    multiplicativeorder

#=
http://rosettacode.org/wiki/Multiplicative_order

One possible algorithm that is efficient also for large numbers is the
following: By the Chinese Remainder Theorem, it's enough to calculate the
multiplicative order for each prime exponent p^k of m, and combine the
results with the least common multiple operation. Now the order of a wrt.
to p^k must divide Φ(p^k). Call this number t, and determine it's factors
q^e. Since each multiple of the order will also yield 1 when used as
exponent for a, it's enough to find the least d such that (q^d)*(t/(q^e))
yields 1 when used as exponent.
=#
multiplicativeorder(a, m) = begin
    gcd(a, m) == 1 || error("$a and $m are not coprime")
    res = one(m)
    for (p, k) in factorization(m)
        m = p^k
        t = div(m, p) * (p-1)
        for f in factors(t)
            if powermod(a, f, m) == 1
                res = lcm(res, f)
                break
            end
        end
    end
    res
end
