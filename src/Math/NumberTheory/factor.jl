export
    isperfectsquare,
    factor, eulerphi,
    divisorcount, divisorsigma,
    isperfect, isdeficient, isabundant,
    primefactors, factors,
    least_number_with_d_divisors

isperfectsquare(n::Integer) = n == isqrt(n)^2

Nemo.factor(n::Int128) = (factor ∘ big)(n)
Nemo.factor(n::T) where {T<:Integer} = factor(n, Dict{T, Int})
Nemo.factor(n::Integer, out::Type{O}) where {OP<:Integer, OK<:Integer, O<:Associative{OP, OK}} = begin
    factorization = (factor ∘ fmpz)(n)
    pairs = (convert(OP, p) => convert(OK, k) for (p, k) in factorization)
    out(pairs)
end
Nemo.factor(n::Integer, out::Type{Nemo.Fac}) = (factor ∘ fmpz)(n)

##  Euler's Phi (or: totient) function
Nemo.eulerphi(n::T) where {T<:Integer} = convert(T, (eulerphi ∘ fmpz)(n))
Nemo.eulerphi(f::Associative{T, <:Integer}) where {T<:Integer} = begin
    phi = one(T)
    for (p, k) in f
        phi *= p^(k-1) * (p - 1)
    end
    phi
end

# https://oeis.org/wiki/Divisor_function
divisorcount(n::T) where {T<:Integer} = convert(T, sigma(fmpz(n), 0))
divisorcount(f::Associative{T, <:Integer}) where {T<:Integer} = begin
    c = one(T)
    for k in values(f)
        c *= k + 1
    end
    c
end

divisorsigma(n::T, s = 1) where {T<:Integer} = convert(T, sigma(fmpz(n), s))
divisorsigma(f::Associative{T, <:Integer}, s = 1) where {T<:Integer} = begin
    s >= 0 || error("Argument 's' must be an integer greater or equal 0")
    s == 0 && return divisorcount(f)

    σ = one(T)
    for (p, k) in f
        σ *= (p^((k + 1) * s) - 1) ÷ (p^s - 1)
    end
    σ
end

isperfect(n::Integer) = divisorsigma(n, 1) - n == n
isdeficient(n::Integer) = divisorsigma(n, 1) - n < n
isabundant(n::Integer) = divisorsigma(n, 1) - n > n

primefactors(n::Integer) = (sort! ∘ collect ∘ keys ∘ factor)(n)

# http://rosettacode.org/wiki/Factors_of_an_integer
factors(n::T, negative::Bool = false) where {T<:Integer} = begin
    n > 0 || error("Argument 'n' must be an integer greater 0")

    f = [one(n)]
    for (p, k) in factor(n)
        f = reduce(vcat, f, [f * p^j for j in 1:k])::Array{T,1}
    end

    if length(f) == 1
        f = [one(n), n]
    else
        sort!(f)
    end

    negative ? flatten([f -f]') : f
end

indexfactorization2number(x::Array{T,1}) where {T<:Integer} =
    prod(big(nthprime(i))^k for (i, k) in enumerate(x))

# http://www.primepuzzles.net/problems/prob_019.htm
least_number_with_d_divisors(d::Integer) =
    minimum(indexfactorization2number(e) for e in least_number_with_d_divisors_exponents(d))

least_number_with_d_divisors_exponents(d::T, i::Int = 1, prevn::T = zero(T)) where {T<:Integer} = begin
    d <= 1 && return Vector{T}[T[]]

    f = factor(d, SortedDict{T, Int})
    pmax = last(f)[1]
    k = sum(values(f))

    p = nthprime(k+i-1)
    p_i = nthprime(i)
    m = floor(Integer, log(p) / log(p_i))

    c = [pmax]
    for b in 2:m
        !(b in keys(f)) && continue

        for a in b:m
            a*b <= pmax && continue
            d % (a*b) != 0 && continue
            first(primefactors(a)) < b && continue
            i > 1 && a*b > prevn && continue

            push!(c, a*b)
        end
    end

    ans = Vector{T}[]
    for ni in c
        for tailn in least_number_with_d_divisors_exponents(d ÷ ni, i+1, ni)
            push!(tailn, ni-1)
            push!(ans, tailn)
        end
    end

    i == 1 ? [reverse(x) for x in ans] : ans
end
