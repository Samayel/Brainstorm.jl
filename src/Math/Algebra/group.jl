zero(a::GroupElem) = zero(parent(a))
one(a::GroupElem) = one(parent(a))

# http://sagenb.org/src/groups/generic.py
multiple(a::GroupElem, n::Integer, op) = begin
    if op === +
        return multiple_add(a, n)
    elseif op === *
        return multiple_mul(a, n)
    else
        throw(MethodError())
    end
end

multiple_add(a::GroupElem, n::Integer) = begin
    n == 0 && return zero(a)

    if n < 0
        n = -n
        a = -a
    end

    n == 1 && return a

    # check for idempotence, and store the result otherwise
    aa = +(a, a)
    aa == a && return a

    n == 2 && return aa
    n == 3 && return +(aa, a)
    n == 4 && return +(aa, aa)

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
        apow = +(apow, apow)
        n = n >> 1
    end
    power = apow
    n = n >> 1

    # now multiply that least-significant bit in...
    m == 1 && (power = +(power, a))

    # and this is straight from the book.
    while n != 0
        apow = +(apow, apow)
        n & 1 != 0 && (power = +(power, apow))
        n = n >> 1
    end

    power
end

multiple_mul(a::GroupElem, n::Integer) = begin
    n == 0 && return one(a)

    if n < 0
        n = -n
        a = inv(a)
    end

    n == 1 && return a

    # check for idempotence, and store the result otherwise
    aa = *(a, a)
    aa == a && return a

    n == 2 && return aa
    n == 3 && return *(aa, a)
    n == 4 && return *(aa, aa)

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
        apow = *(apow, apow)
        n = n >> 1
    end
    power = apow
    n = n >> 1

    # now multiply that least-significant bit in...
    m == 1 && (power = *(power, a))

    # and this is straight from the book.
    while n != 0
        apow = *(apow, apow)
        n & 1 != 0 && (power = *(power, apow))
        n = n >> 1
    end

    power
end

# TODO: improve! => http://sagenb.org/src/groups/generic.py
log{T<:GroupElem}(a::T, base::T, ord::ZZ) = log(a, base, BigInt(ord))
log{T<:GroupElem}(a::T, base::T, ord::Integer) = begin
    n = 1
    b = base
    while a != b
        n += 1
        b *= base
    end
    n
end
