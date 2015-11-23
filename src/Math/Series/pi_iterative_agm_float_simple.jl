module Simple

const guard_digits = 5
const eps_digits = 5
const bits_per_digit = log2(10)

pi{T<:Integer}(digits::T) = begin
    prec = ceil(T, bits_per_digit * (digits + guard_digits + eps_digits))
    with_bigfloat_precision(prec) do
        a = big(1.0)
        b = 1 / sqrt(big(2.0))

        s = big(0.0)
        d = a - b

        n = 0
        ϵ = 1 / big(10)^(digits + eps_digits)

        while d >= ϵ
            s += big(2)^n * d^2
            a, b = (a + b) / 2, sqrt(a * b)
            d = a - b
            n += 1
        end

        4*a*a / (1 - s)
    end
end

end
