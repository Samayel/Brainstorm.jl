module Sqrt

using Brainstorm.Math.GMP: set!, add!, mul!, neg!, lsh!, rsh!

const bits_per_digit = log2(10)
const guard_rounds = 1

#
# Compute int(sqrt(x) * 10^digits)
#
# This is done using Newton-Raphson method.
#
sqrt(digits::Integer, x::Integer) = begin
    r, e = _reciprocalsqrt(digits, x)

    # (r / 2^e) * n * 10^digits
    s = big(5)^digits
    mul!(r, x)
    mul!(r, s)
    rsh!(r, e - digits)

    r
end

rsqrt(digits::Integer, x::Integer) = begin
    r, e = _reciprocalsqrt(digits, x)

    # (r / 2^e) * 10^digits
    s = big(5)^digits
    mul!(r, s)
    rsh!(r, e - digits)

    r
end

_reciprocalsqrt(digits, x) = begin
    # initial guess is accurate to eᵢ bits
    eᵢ = Int64(50)
    rᵢ = trunc(BigInt, (Int64(1) << eᵢ) / Base.sqrt(x))

    target_precision = ceil(Int64, digits * bits_per_digit) << guard_rounds

    oᵢ, wᵢ, dᵢ = big(0), big(0), big(0)
    while eᵢ <= target_precision
        peᵢ = eᵢ
        eᵢ = eᵢ << 1

        #
        # http://www.numberworld.org/y-cruncher/algorithms/invsqrt.html
        # http://cs.stackexchange.com/a/37645
        #
        #      w_i+1 = r_i^2
        #            = r_i'^2 / 2^(2*e_i)
        #  => w_i+1' = r_i'^2
        #
        #      d_i+1 = 1 - w_i+1 * x
        #            = 1 - r_i'^2 / 2^(2*e_i) * x
        #            = (2^(2*e_i) - r_i'^2 * x) / 2^(2*e_i)
        #  => d_i+1' = 2^(2*e_i) - w_i+1' * x
        #
        #      r_i+1 = r_i * (1 + d_i+1 / 2)
        #            = r_i' / 2^e_i * (1 + (d_i+1' / 2) / 2^(2*e_i))
        #            = r_i' / 2^e_i * (2^(2*e_i) + d_i+1' / 2) / 2^(2*e_i)
        #            = r_i' * (2^(2*e_i) + d_i+1' / 2) / 2^e_i / 2^(2*e_i)
        #  => r_i+1' = r_i' * (2^(2*e_i) + d_i+1' / 2) / 2^e_i
        #

        # oᵢ = 1 << eᵢ
        set!(oᵢ, 1)
        lsh!(oᵢ, eᵢ)

        # wᵢ = rᵢ * rᵢ
        set!(wᵢ, rᵢ)
        mul!(wᵢ, rᵢ)
        # dᵢ = oᵢ - wᵢ * x
        set!(dᵢ, wᵢ)
        mul!(dᵢ, x)
        neg!(dᵢ)
        add!(dᵢ, oᵢ)
        # rᵢ = (rᵢ * (oᵢ + dᵢ >> 1)) >> peᵢ
        rsh!(dᵢ, 1)
        add!(dᵢ, oᵢ)
        mul!(rᵢ, dᵢ)
        rsh!(rᵢ, peᵢ)
    end

    rᵢ, eᵢ
end

end
