module Inplace

using Brainstorm.Math.GMP: set!, add!, sub!, mul!, div!, neg!, isqrt!, rsh!, lsh!

const guard_digits = 5
const eps_digits = 5

pi(digits::Integer) = begin
    o = big(10)^(digits + guard_digits + eps_digits)
    osqr = o^2
    t = big(0)

    # a = 1
    a = big(0)
    set!(a, o)

    # b = 1 / sqrt(2)
    set!(t, osqr)
    lsh!(t, 1)
    isqrt!(t)
    b = div(osqr, t)

    s = big(0)
    d = a - b

    n = 0
    ϵ = 10^eps_digits

    while d >= ϵ
        # s += 2^n * d^2
        mul!(d, d)
        lsh!(d, n)
        add!(s, d)

        # a, b = (a + b) / 2, sqrt(a * b)
        set!(t, a)
        add!(t, b)
        rsh!(t, 1)

        mul!(b, a)
        isqrt!(b)
        set!(a, t)

        # d = a - b
        set!(d, a)
        sub!(d, b)

        n += 1
    end

    # 4*a^2 / (1 - s)
    neg!(s)
    add!(s, osqr)
    mul!(s, big(10)^(guard_digits + eps_digits))
    mul!(a, a)
    mul!(a, o)
    lsh!(a, 2)
    div!(a, s)
end

end
