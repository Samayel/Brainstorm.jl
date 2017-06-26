export
    ContinuedFraction, NonPeriodicContinuedFraction, PeriodicContinuedFraction,
    confrac,
    ContinuedFractionConvergentsIterator, NonPeriodicContinuedFractionConvergentsIterator, PeriodicContinuedFractionConvergentsIterator,
    convergents


abstract type ContinuedFraction{T<:Integer} end

@auto_hash_equals struct NonPeriodicContinuedFraction{T<:Integer} <: ContinuedFraction{T}
    denominators::Array{T,1}
end

@auto_hash_equals struct PeriodicContinuedFraction{T<:Integer} <: ContinuedFraction{T}
    denominators::Array{T,1}
    periodstart::Int
end


Base.start(::ContinuedFraction) = 1
Base.next(it::NonPeriodicContinuedFraction, state) = it.denominators[state], state + 1
Base.next(it::PeriodicContinuedFraction, state) = it.denominators[state], (state == length(it.denominators) ? it.periodstart : state + 1)
Base.done(it::NonPeriodicContinuedFraction, state) = state > length(it.denominators)
Base.done(::PeriodicContinuedFraction, _) = false

Base.eltype(it::ContinuedFraction) = Base.eltype(typeof(it))
Base.eltype(::Type{NonPeriodicContinuedFraction{T}}) where {T} = T
Base.eltype(::Type{PeriodicContinuedFraction{T}}) where {T} = T

Base.length(it::NonPeriodicContinuedFraction) = length(it.denominators)
Base.iteratorsize(::PeriodicContinuedFraction) = Base.IsInfinite()


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


Base.rationalize(cf::ContinuedFraction{T}, len::Int = -1) where {T<:Integer} = begin
    len >= 0 || (len = length(cf.denominators))
    len > 0 || return one(T) // zero(T)   # [] = +Inf;  [a; b] = a + 1 / [b] = a + 1 / (b + 1 / []) = a + 1 / (b + 1 / +Inf) = a + 1 / b

    @pipe cf |> convergents |> drop(_, len-1) |> first |> Rational(_...)
end


confrac(d::Array{T,1}) where {T<:Integer} = NonPeriodicContinuedFraction(d)
confrac(d::Array{T,1}, p::Int) where {T<:Integer} = PeriodicContinuedFraction(d, p)

confrac(rat::Rational{T}) where {T<:Integer} = begin
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
confrac(n::T, δ::T, d::T) where {T<:Integer} = begin
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
        biM = d > 0 ? biK ÷ d : (d + 1 - biK) ÷ (-d)
    else
        biM = d > 0 ? (biK + 1 - d) ÷ d : (-biK) ÷ (-d)
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
            P = (δ - M^2) ÷ P
            Z = (sqrtδ + M) ÷ P
            M = Z * P - M
            cont += 1
        else
            biP = (δ - biM^2) ÷ biP
            Z = (sqrtδ + biM + (biP > 0 ? 0 : 1)) ÷ biP
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


abstract type ContinuedFractionConvergentsIterator{T<:Integer} end

struct NonPeriodicContinuedFractionConvergentsIterator{T<:Integer} <: ContinuedFractionConvergentsIterator{T}
    cf::NonPeriodicContinuedFraction{T}
end

struct PeriodicContinuedFractionConvergentsIterator{T<:Integer} <: ContinuedFractionConvergentsIterator{T}
    cf::PeriodicContinuedFraction{T}
end

convergents(cf::NonPeriodicContinuedFraction) = NonPeriodicContinuedFractionConvergentsIterator(cf)
convergents(cf::PeriodicContinuedFraction) = PeriodicContinuedFractionConvergentsIterator(cf)

Base.start(it::ContinuedFractionConvergentsIterator{T}) where {T<:Integer} = start(it.cf), one(T), zero(T), zero(T), one(T)
Base.next(it::ContinuedFractionConvergentsIterator, state) = begin
    cfs, p, q, r, s = state

    c, cfs = next(it.cf, cfs)
    p, q, r, s = c*p+r, c*q+s, p, q

    (p, q), (cfs, p, q, r, s)
end
Base.done(it::ContinuedFractionConvergentsIterator, state) = done(it.cf, state[1])

Base.eltype(it::ContinuedFractionConvergentsIterator) = Base.eltype(typeof(it))
Base.eltype(::Type{NonPeriodicContinuedFractionConvergentsIterator{T}}) where {T} = Tuple{T,T}
Base.eltype(::Type{PeriodicContinuedFractionConvergentsIterator{T}}) where {T} = Tuple{T,T}

Base.length(it::NonPeriodicContinuedFractionConvergentsIterator) = length(it.cf.denominators)
Base.iteratorsize(::PeriodicContinuedFractionConvergentsIterator) = Base.IsInfinite()
