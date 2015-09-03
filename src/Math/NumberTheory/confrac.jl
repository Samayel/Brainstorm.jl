export
    ContinuedFraction,
    confrac,
    ContinuedFractionConvergentsIterator,
    convergents


@auto_hash_equals immutable ContinuedFraction{T<:Integer}
    denominators::Array{T,1}
    periodstart::Int
end


Base.show(io::IO, cf::ContinuedFraction) = begin
    print(io, "[")

    len = length(cf.denominators)
    len > 0 && print(io, cf.denominators[1])

    hasperiod = false
    for i = 2:len
        print(io, i == 2 ? ";" : ",")
        i == cf.periodstart && (print(io, "("); hasperiod = true)
        print(io, cf.denominators[i])
    end

    hasperiod && print(io, ")")
    print(io, "]")
end

Base.rationalize{T<:Integer}(cf::ContinuedFraction{T}, len::Int = -1) = begin
    len >= 0 || (len = length(cf.denominators))
    len > 0 || return zero(Rational{T})

    d = cf.denominators
    cf.periodstart >= 1 && (d = chain(d[1:cf.periodstart-1], cycle(d[cf.periodstart:end])))

    foldr((x, y) -> x + 1 // y, collect(take(d, len)))
end


confrac{T<:Integer}(d::Array{T,1}, p::Int = 0) = ContinuedFraction(d, p)

confrac{T<:Integer}(rat::Rational{T}) = begin
    n, d = rat.num, rat.den

    denominators = T[]

    while d != 0
        a = fld(n, d)
        push!(denominators, a)
        n, d = d, n - a * d
    end

    ContinuedFraction(denominators, 0)
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

    ContinuedFraction(denominators, periodstart)
end



immutable ContinuedFractionConvergentsIterator{T<:Integer}
    cf::ContinuedFraction{T}
end

convergents(cf::ContinuedFraction) = ContinuedFractionConvergentsIterator(cf)

Base.start(::ContinuedFractionConvergentsIterator) = 1
Base.next(it::ContinuedFractionConvergentsIterator, state) = rationalize(it.cf, state), state + 1
Base.done(it::ContinuedFractionConvergentsIterator, state) = it.cf.periodstart <= 0 && state > length(it.cf.denominators)

Base.eltype(it::ContinuedFractionConvergentsIterator) = Base.eltype(typeof(it))
Base.eltype{T}(::Type{ContinuedFractionConvergentsIterator{T}}) = Rational{T}
#Base.length(it::ContinuedFractionConvergentsIterator) = ...
