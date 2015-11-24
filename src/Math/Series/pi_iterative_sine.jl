module Sine

using Brainstorm.Math.MPFR: add!, precision!

const guard_digits = 5
const bits_per_digit = log2(10)

pi{T<:Integer}(digits::T) = begin
    with_bigfloat_precision(8) do
        target_prec = ceil(T, bits_per_digit * (digits + guard_digits))
        _pi(target_prec)
    end
end

# http://numbers.computation.free.fr/Constants/Pi/iterativePi.html
_pi(target_prec) = begin
    prec = 20
    set_bigfloat_precision(prec)
    α = big(355/113)

    while prec < target_prec
        prec = min(3*prec, target_prec)
        precision!(α, prec); set_bigfloat_precision(prec)

        add!(α, sin(α))
    end
    α
end

end
