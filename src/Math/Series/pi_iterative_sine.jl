module _Sine

using Brainstorm._Math._MPFR: add!, precision!

const guard_digits = 5
const bits_per_digit = log2(10)

pi(digits::T) where {T<:Integer} = begin
    setprecision(8) do
        target_prec = ceil(T, bits_per_digit * (digits + guard_digits))
        _pi(target_prec)
    end
end

# http://numbers.computation.free.fr/Constants/Pi/iterativePi.html
_pi(target_prec) = begin
    prec = 20
    setprecision(prec)
    α = big(355/113)

    while prec < target_prec
        prec = min(3*prec, target_prec)
        precision!(α, prec); setprecision(prec)

        add!(α, sin(α))
    end
    α
end

end
