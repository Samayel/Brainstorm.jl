export
    decimalperiod

#=
http://mathworld.wolfram.com/DecimalExpansion.html

"When a rational number m/n with (m,n)==1 is expanded, the period begins
after s terms and has length t, where s and t are the smallest numbers
satisfying 10^s=10^(s+t) (mod n)."
=#
decimalperiod(_, n) = begin
    n0 = one(n)
    for (p, k) in factorization(n)
        p == 2 && continue
        p == 5 && continue
        n0 *= p^k
    end
    n0 == 1 ? zero(n) : multiplicativeorder(10, n0)
end
