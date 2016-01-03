@reexport module GroupAlgorithm

abstract Algorithm

immutable BabyStepGiantStep <: Algorithm end
immutable PollardRho        <: Algorithm end
immutable Schoof            <: Algorithm end

end

# https://en.wikipedia.org/wiki/Counting_points_on_elliptic_curves#Baby-step_giant-step
order{T<:FiniteFieldElem}(ec::Curve{T}, ::Type{GroupAlgorithm.BabyStepGiantStep}) = begin
    o = order(field(ec))
    q = convert(BigInt, o)
    m = convert(BigInt, root(o, 4) + 1)

    L = big(1)
    N = big(0)

    while true
        # random element P=(x,y) ∈ E(𝐅q)
        P = rand(ec)
        while isideal(P)
            P = rand(ec)
        end

        # Pⱼ[x] == j => jP == (x, p(x)); Pm = mP
        Pⱼ, _, Pm = logpx(P, m)
        Q = (q+1) * P
        P2m = Pm + Pm

        # find k, j: Q + k(2mP) = R = ±Pⱼ (the x-coordinates are compared)
        k = zero(m)
        R = Q
        while true
            isideal(R) && break
            R.x ∈ keys(Pⱼ) && break
            k += 1
            R += P2m
        end
        j = isideal(R) ? 0 : Pⱼ[R.x]
        # (q + 1 + 2mk ∓ j)P = MP = 𝒪
        M = q + 1 + 2*m*k + (R == (j*P) ? -1 : 1)*j

        for (p, e) in factorization(M)
            for _ in 1:e
                N = M ÷ p
                !isideal(N*P) && break
                M = N
            end
        end
        # M is the order of the point P
        L = lcm(L, M)

        # L divides more than one integer N in (q+1-2√q, q+1+2√q)?
        sq = isqrt(q)
        N = q + 1 - 2(sq-1)
        N₊ = Array{typeof(N), 1}()
        while N <= q + 1 + 2(sq+1)
            N % L == 0 && push!(N₊, N)
            length(N₊) > 1 && break
            N += 1
        end
        # if not => N is the cardinality of E(𝐅q)
        length(N₊) == 1 && return N₊[1]
    end
end

logpx(p::Point, m::Integer) = begin
    pᵢ = Dict{typeof(p.x), typeof(m)}()
    o = zero(m)
    q = ideal(curve(p))
    for i in 1:m
        q += p
        isideal(q) && (o = i; break)
        q.x ∈ keys(pᵢ) && continue
        pᵢ[q.x] = i
    end
    pᵢ, o, q
end

# http://andrea.corbellini.name/2015/05/23/elliptic-curve-cryptography-finite-fields-and-discrete-logarithms/
order(p::Point, N::Integer) = begin
    for n in factors(N)
        isideal(n*p) && return n
    end

    error("$(p) is not an element in a subgroup")
end

gen(ec::Curve, N::Integer, n::Integer) = begin
    isprime(n) || error("order of the subgroup ($n) must be prime")

    h, r = divrem(N, n)
    r == 0 || error("order of the subgroup ($n) must be a divisor of $N")

    for i in 1:100
        P = rand(ec)
        G = h*P
        isideal(G) || return G
    end

    error("no generator of a subgroup with order $n could be found")
end
