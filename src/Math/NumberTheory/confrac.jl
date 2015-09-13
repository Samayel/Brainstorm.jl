export
    ContinuedFraction, NonPeriodicContinuedFraction, PeriodicContinuedFraction,
    confrac,
    ContinuedFractionConvergentsIterator, NonPeriodicContinuedFractionConvergentsIterator, PeriodicContinuedFractionConvergentsIterator,
    convergents


abstract ContinuedFraction{T<:Integer}

@auto_hash_equals immutable NonPeriodicContinuedFraction{T<:Integer} <: ContinuedFraction{T}
    denominators::Array{T,1}
end

@auto_hash_equals immutable PeriodicContinuedFraction{T<:Integer} <: ContinuedFraction{T}
    denominators::Array{T,1}
    periodstart::Int
end


Base.start(::ContinuedFraction) = 1
Base.next(it::NonPeriodicContinuedFraction, state) = it.denominators[state], state + 1
Base.next(it::PeriodicContinuedFraction, state) = it.denominators[state], (state == length(it.denominators) ? it.periodstart : state + 1)
Base.done(it::NonPeriodicContinuedFraction, state) = state > length(it.denominators)
Base.done(::PeriodicContinuedFraction, _) = false

Base.eltype(it::ContinuedFraction) = Base.eltype(typeof(it))
Base.eltype{T}(::Type{NonPeriodicContinuedFraction{T}}) = T
Base.eltype{T}(::Type{PeriodicContinuedFraction{T}}) = T

Base.length(it::NonPeriodicContinuedFraction) = length(it.denominators)


Base.show(io::IO, cf::ContinuedFraction) = begin
    print(io, "[")
    for (i, d) in enumerate(cf.denominators)
        i == 2 && print(io, ";")
        i >= 3 && print(io, ",")
        isa(cf, PeriodicContinuedFraction) && i == cf.periodstart && print(io, "(")
        print(io, d)
    end
    isa(cf, PeriodicContinuedFraction) && print(io, ")")
    print(io, "]")
end


Base.rationalize{T<:Integer}(cf::ContinuedFraction{T}, len::Int = -1) = begin
    len >= 0 || (len = length(cf.denominators))
    len > 0 || return one(T) // zero(T)   # [] = +Inf;  [a; b] = a + 1 / [b] = a + 1 / (b + 1 / []) = a + 1 / (b + 1 / +Inf) = a + 1 / b

    @pipe cf |> convergents |> drop(_, len-1) |> first |> Rational(_...)
end


confrac{T<:Integer}(d::Array{T,1}) = NonPeriodicContinuedFraction(d)
confrac{T<:Integer}(d::Array{T,1}, p::Int) = PeriodicContinuedFraction(d, p)

confrac{T<:Integer}(rat::Rational{T}) = begin
    n, d = rat.num, rat.den

    denominators = T[]
    while d != 0
        a = fld(n, d)
        push!(denominators, a)
        n, d = d, n - a * d
    end

    confrac(denominators)
end

# == (n + sqrt(δ)) / d
confrac{T<:Integer}(n::T, δ::T, d::T) = begin
    d == 0 && throw(Error("The denominator is zero."))
    δ < 0 && throw(Error("The number is not real, so it does not have a continued fraction expansion."))
    δ == 0 && return confrac(n // d)

    if (δ - n^2) % d != 0
        δ *= d^2
        n *= abs(d)
        d *= abs(d)
    end

    sqrtδ = isqrt(δ)
    sqrtδ^2 == δ && return confrac((n + sqrtδ) // d)

    biP = d
    biK = sqrtδ + (biP > 0 ? 0: 1) + n
    if biK > 0
        biM = d > 0 ? div(biK, d) : div(d + 1 - biK, -d)
    else
        biM = d > 0 ? div(biK + 1 - d, d) : div(-biK, -d)
    end

    denominators = T[]
    periodstart = 0
    push!(denominators, biM)
    biM = biM * d  - n

    cont = -1
    K = P = L = M = -1

    while (cont < 0) || (K != P) || (L != M)
        if (cont < 0) && (biP > 0) && (biP <= sqrtδ + biM) && (biM > 0) && (biM <= sqrtδ)
            # period starts
            periodstart = length(denominators) + 1
            K = P = biP
            L = M = biM
            cont = 0
        end

        if cont >= 0
            # both numerator and denominator are positive
            P = div(δ - M^2, P)
            Z = div(sqrtδ + M, P)
            M = Z * P - M
            cont += 1
        else
            biP = div(δ - biM^2, biP)
            Z = div(sqrtδ + biM + (biP > 0 ? 0 : 1), biP)
            biM = Z * biP - biM
        end

        push!(denominators, Z)
        #if (cont > 100000)
        #    # too many convergents
        #    break
        #end
    end

    confrac(denominators, periodstart)
end


abstract ContinuedFractionConvergentsIterator{T<:Integer}

immutable NonPeriodicContinuedFractionConvergentsIterator{T<:Integer} <: ContinuedFractionConvergentsIterator{T}
    cf::NonPeriodicContinuedFraction{T}
end

immutable PeriodicContinuedFractionConvergentsIterator{T<:Integer} <: ContinuedFractionConvergentsIterator{T}
    cf::PeriodicContinuedFraction{T}
end

convergents(cf::NonPeriodicContinuedFraction) = NonPeriodicContinuedFractionConvergentsIterator(cf)
convergents(cf::PeriodicContinuedFraction) = PeriodicContinuedFractionConvergentsIterator(cf)

Base.start{T<:Integer}(it::ContinuedFractionConvergentsIterator{T}) = start(it.cf), one(T), zero(T), zero(T), one(T)
Base.next(it::ContinuedFractionConvergentsIterator, state) = begin
    cfs, p, q, r, s = state

    c, cfs = next(it.cf, cfs)
    p, q, r, s = c*p+r, c*q+s, p, q

    (p, q), (cfs, p, q, r, s)
end
Base.done(it::ContinuedFractionConvergentsIterator, state) = done(it.cf, state[1])

Base.eltype(it::ContinuedFractionConvergentsIterator) = Base.eltype(typeof(it))
Base.eltype{T}(::Type{NonPeriodicContinuedFractionConvergentsIterator{T}}) = Tuple{T,T}
Base.eltype{T}(::Type{PeriodicContinuedFractionConvergentsIterator{T}}) = Tuple{T,T}

Base.length(it::NonPeriodicContinuedFractionConvergentsIterator) = length(it.cf.denominators)
