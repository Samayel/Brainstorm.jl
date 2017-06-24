module _Simple

const guard_digits = 5
const eps_digits = 5

pi(digits::Integer) = begin
    o = big(10)^(digits + guard_digits + eps_digits)
    osqr = o^2

    # a = 1
    # b = 1 / sqrt(2)
    a = o
    b = osqr ÷ isqrt(osqr << 1)

    s = big(0)
    d = a - b

    n = 0
    ϵ = 10^eps_digits

    while d >= ϵ
        # s += 2^n * d^2
        s += (d^2) << n
        # a, b = (a + b) / 2, sqrt(a * b)
        a, b = (a + b) >> 1, isqrt(a * b)
        d = a - b
        n += 1
    end

    # 4*a^2 / (1 - s)
    (4*a*a*o) ÷ ((osqr - s) * big(10)^(guard_digits + eps_digits))
end

end
