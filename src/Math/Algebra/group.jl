zero(a::GroupElem) = zero(parent(a))
one(a::GroupElem) = one(parent(a))

# http://sagenb.org/src/groups/generic.py
multiple(a::GroupElem, n::Integer, op) = begin
    if op === +
        return multiple(a, n, +, x -> -x, zero(a))
    elseif op === *
        return multiple(a, n, *, inv, one(a))
    else
        throw(MethodError())
    end
end

multiple{T<:GroupElem}(a::T, n::Integer, op, inverse, identity::T) = begin
    n == 0 && return identity

    if n < 0
        n = -n
        a = inverse(a)
    end

    n == 1 && return a

    # check for idempotence, and store the result otherwise
    aa = op(a, a)
    aa == a && return a

    n == 2 && return aa
    n == 3 && return op(aa, a)
    n == 4 && return op(aa, aa)

    # since we've computed a^2, let's start squaring there
    # so, let's keep the least-significant bit around, just
    # in case.
    m = n & 1
    n = n >> 1

    # One multiplication can be saved by starting with
    # the second-smallest power needed rather than with 1
    # we've already squared a, so let's start there.
    apow = aa
    while n & 1 == 0
        apow = op(apow, apow)
        n = n >> 1
    end
    power = apow
    n = n >> 1

    # now multiply that least-significant bit in...
    m == 1 && (power = op(power, a))

    # and this is straight from the book.
    while n != 0
        apow = op(apow, apow)
        n & 1 != 0 && (power = op(power, apow))
        n = n >> 1
    end

    power
end

# TODO: improve! => http://sagenb.org/src/groups/generic.py
log{T<:GroupElem}(a::T, base::T, ord::fmpz) = log(a, base, BigInt(ord))
log{T<:GroupElem}(a::T, base::T, ord::Integer) = begin
    n = 1
    b = base
    while a != b
        n += 1
        b *= base
    end
    n
end
