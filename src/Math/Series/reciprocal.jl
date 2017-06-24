module _Reciprocal

using Brainstorm._Math._GMP: set!, add!, sub!, mul!, neg!, lsh!, rsh!

const bits_per_digit = log2(10)
const guard_rounds = 1

#
# Compute int(1/x * 10^digits)
#
# This is done using Newton-Raphson method.
#
reciprocal(digits::Integer, x::Integer) = begin
    r, e = _reciprocal(digits, x)

    # (r / 2^e) * 10^digits
    s = big(5)^digits
    mul!(r, s)
    rsh!(r, e - digits)

    r
end

_reciprocal(digits, x) = begin
    # initial guess is accurate to eᵢ bits
    eᵢ = Int64(50)
    rᵢ = trunc(BigInt, (Int64(1) << eᵢ) / x)

    target_precision = ceil(Int64, digits * bits_per_digit) << guard_rounds

    oᵢ, dᵢ = big(0), big(0), big(0)
    while eᵢ <= target_precision
        peᵢ = eᵢ
        eᵢ = eᵢ << 1

        # oᵢ = 1 << eᵢ
        set!(oᵢ, 1)
        lsh!(oᵢ, eᵢ)

        #
        # http://www.numberworld.org/y-cruncher/algorithms/division.html
        #
        # d_i+1 = r_i * x - 1
        #       = (r_i' * x - 2^e_i) / 2^e_i
        #       = (r_i' * x * 2^e_i - 2^(2*e_i)) / 2^(2*e_i)
        #
        # r_i+1 = r_i * (1 - d_i+1)
        #       = r_i' / 2^e_i * (1 - d_i+1' / 2^(2*e_i))
        #       = r_i' * (2^(2*e_i) - d_i+1') / 2^e_i / 2^(2*e_i)
        #

        # dᵢ = (rᵢ * x) << peᵢ - oᵢ
        set!(dᵢ, rᵢ)
        mul!(dᵢ, x)
        lsh!(dᵢ, peᵢ)
        sub!(dᵢ, oᵢ)
        # rᵢ = (rᵢ * (oᵢ - dᵢ)) >> peᵢ
        neg!(dᵢ)
        add!(dᵢ, oᵢ)
        mul!(rᵢ, dᵢ)
        rsh!(rᵢ, peᵢ)
    end

    rᵢ, eᵢ
end

end
