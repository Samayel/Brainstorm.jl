module _Inplace

using Brainstorm._Math._MPFR: set!, add!, sub!, mul!, neg!, sqrt!, rsh!, lsh!

const guard_digits = 5
const eps_digits = 5
const bits_per_digit = log2(10)

pi{T<:Integer}(digits::T) = begin
    prec = ceil(T, bits_per_digit * (digits + guard_digits + eps_digits))
    setprecision(prec) do
        _pi(digits)
    end
end

_pi(digits) = begin
    a = big(1.0)
    # b = 1 / sqrt(big(2.0))
    b = big(1.0)
    rsh!(b, 1)
    sqrt!(b)

    s = big(0.0)
    d = a - b

    n = 0
    ϵ = 1 / big(10)^(digits + eps_digits)
    t = big(0.0)

    while d >= ϵ
        # s += big(2)^n * d^2
        mul!(d, d)
        lsh!(d, n)
        add!(s, d)

        # a, b = (a + b) / 2, sqrt(a * b)
        set!(t, a)
        add!(t, b)
        rsh!(t, 1)

        mul!(b, a)
        sqrt!(b)
        set!(a, t)

        # d = a - b
        set!(d, a)
        sub!(d, b)

        n += 1
    end

    # 4*a*a / (1 - s)
    mul!(a, a)
    lsh!(a, 2)
    neg!(s)
    add!(s, 1)
    a / s
end

end
