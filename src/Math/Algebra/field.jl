
sqrt(a::FiniteFieldElem) = root(a, 2)

# http://trac.sagemath.org/ticket/7931
# http://sagenb.org/src/rings/finite_rings/element_base.pyx
root(a::FiniteFieldElem, n::Integer) = root(a, ZZ(n))
root(a::FiniteFieldElem, n::ZZ) = begin
    n > 1 || throw(DomainError())
    iszero(a) && return a

    K = parent(a)
    q = order(K)

    if isone(a)
        GCD = gcd(n, q-1)
        GCD == 1 && return a

        g = gen(K) # TODO: The generator is guaranteed to be a multiplicative generator only if the field is generated by a Conway polynomial.
        q1overn = (q-1) ÷ GCD
        nthroot = g^q1overn
        return nthroot
    end

    m = n % (q-1)
    m == 0 && error("$(a) has no $(n)th root in $(K)")

    # GCD = α*m + β*(q-1), so 1/m = α/GCD (mod q-1)
    GCD, α, β = gcdx(m, q-1)
    GCD == 1 && return a^α

    m = GCD
    q1overn = (q-1) ÷ m
    a^q1overn != 1 && error("$(a) has no $(n)th root in $(K)")

    b = a^α
    F = [(ZZ(p), e) for (p, e) in factorization(BigInt(m))]

    g = gen(K) # TODO: The generator is guaranteed to be a multiplicative generator only if the field is generated by a Conway polynomial.
    for (r, v) in F
        k, h = remove(q-1, r)
        z = h * invmod(-h, r^v)::typeof(h)
        x = (1 + z) ÷ (r^v)
        if k == 1
            b = b^x
        else
            t = log(b^h, g^(r^v * h), r^(k-v))
            b = b^x * g^(-z*t)
        end
    end
    b
end

sqrts(a::FiniteFieldElem) = roots(a, 2)

# http://trac.sagemath.org/ticket/7931
# http://sagenb.org/src/rings/finite_rings/element_base.pyx
roots(a::FiniteFieldElem, n::Integer) = roots(a, ZZ(n))
roots{T<:FiniteFieldElem}(a::T, n::ZZ) = begin
    n > 1 || throw(DomainError())
    iszero(a) && return [a]

    K = parent(a)
    q = order(K)

    if isone(a)
        GCD = gcd(n, q-1)
        GCD == 1 && return [a]

        g = gen(K) # TODO: The generator is guaranteed to be a multiplicative generator only if the field is generated by a Conway polynomial.
        q1overn = (q-1) ÷ GCD
        nthroot = g^q1overn
        return [nthroot^i for i in 0:(GCD-1)]
    end

    m = n % (q-1)
    m == 0 && return T[]

    # GCD = α*m + β*(q-1), so 1/m = α/GCD (mod q-1)
    GCD, α, β = gcdx(m, q-1)
    GCD == 1 && return [a^α]

    m = GCD
    q1overn = (q-1) ÷ m
    a^q1overn != 1 && return T[]

    b = a^α
    F = [(ZZ(p), e) for (p, e) in factorization(BigInt(m))]

    g = gen(K) # TODO: The generator is guaranteed to be a multiplicative generator only if the field is generated by a Conway polynomial.
    for (r, v) in F
        k, h = remove(q-1, r)
        z = h * invmod(-h, r^v)::typeof(h)
        x = (1 + z) ÷ (r^v)
        if k == 1
            b = b^x
        else
            t = log(b^h, g^(r^v * h), r^(k-v))
            b = b^x * g^(-z*t)
        end
    end

    nthroot = g^q1overn
    L = [b]
    for _ in 1:(m-1)
        b *= nthroot
        push!(L, b)
    end
    L
end

rand(F::Union{FqFiniteField,FqNmodFiniteField}) = begin
    p = characteristic(F)
    k = degree(F)
    g = gen(F)

    x = zero(F)
    for i in 0:k-1
        x += g^i * rand(0:convert(BigInt, p-1))
    end
    x
end