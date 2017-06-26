
Combinatorics.permutations(a, c) = permutations(a, c, sum(c))
Combinatorics.permutations(a, c, k::Integer) = MultisetPermuations(a, c, k)

struct MultisetPermuations{T,U,V}
    a::T
    c::U
    k::V
end

Base.start(p::MultisetPermuations) = begin
    s = [fill(i, p.c[i]) for i in eachindex(p.a)] |> flatten
    p.k <= length(s) ? s[1:p.k] : [length(p.a) + 1]
end

Base.next(p::MultisetPermuations, s) = begin
    permutation = [p.a[si] for si in s]
    p.k > 0 || return permutation, [length(p.a) + 1]

    s = copy(s)
    for i in length(s):-1:1
        s[i] += 1
        while s[i] <= length(p.a) && countnz(s .== s[i]) > p.c[s[i]]
            s[i] += 1
        end

        if s[i] <= length(p.a)
            t = [fill(i, p.c[i] - countnz(s .== i)) for i in eachindex(p.a)] |> flatten
            s[i+1:end] = t[1:(length(s)-i)]
            break
        end
    end

    permutation, s
end

Base.done(p::MultisetPermuations, s) = !isempty(s) && s[1] > length(p.a)

Base.eltype(p::MultisetPermuations) = eltype(typeof(p))
Base.eltype(::Type{MultisetPermuations{T,U,V}}) where {T,U,V} = Array{eltype(T),1}

Base.length(p::MultisetPermuations) = begin
    p.k == 0 && return big(1)

    csum = sum(p.c)
    p.k > csum && return big(0)
    p.k == csum && return multinomial(p.c)

    # http://www.m-hikari.com/ams/ams-2011/ams-17-20-2011/siljakAMS17-20-2011.pdf
    R, z = PowerSeriesRing(QQ, p.k + 1, "z")
    gf = prod(sum(divexact(z^j, fac(j)) for j in 0:m) for m in p.c)
    l = fac(p.k) * coeff(gf, p.k)

    @assert den(l) == 1
    convert(BigInt, num(l))
end
