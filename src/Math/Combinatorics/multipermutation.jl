
Base.permutations{T,U<:Integer}(a::AbstractArray{T,1}, c::AbstractArray{U,1}) =
    permutations(a, c, sum(c))
Base.permutations{T,U<:Integer}(a::AbstractArray{T,1}, c::AbstractArray{U,1}, k::U) =
    MultisetPermuations{T,U}(a, c, k)

immutable MultisetPermuations{T,U}
    a::AbstractArray{T,1}
    c::AbstractArray{U,1}
    k::U
end

Base.start(p::MultisetPermuations) = begin
    s = [fill(i, p.c[i]) for i in eachindex(p.a)] |> flatten
    p.k <= length(s) ? s[1:p.k] : [length(p.a) + 1]
end

Base.next(p::MultisetPermuations, s) = begin
    permutation = [p.a[si] for si in s]
    p.k > 0 || return (permutation, [length(p.a) + 1])

    s = copy(s)
    for i = length(s):-1:1
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

    (permutation, s)
end

Base.done(p::MultisetPermuations, s) = !isempty(s) && s[1] > length(p.a)

Base.eltype(p::MultisetPermuations) = eltype(typeof(p))
Base.eltype{T,U}(::Type{MultisetPermuations{T,U}}) = Array{T,1}

Base.length(p::MultisetPermuations) = begin
    p.k == 0 && return 1

    csum = sum(p.c)
    p.k > csum && return 0
    p.k == csum && return multinomial(p.c)

    s = expand_maclaurin_series(GFPerm(p.c), p.k, Number)
    round(Int, factorial(p.k) * coefficient(s, p.k))
end

immutable GFPerm{T} <: Base.Func{1}
    c::T
end
Base.call(f::GFPerm, z) = gfperm(z, f.c)

# http://www.m-hikari.com/ams/ams-2011/ams-17-20-2011/siljakAMS17-20-2011.pdf
gfperm(t, m::Integer) = sum([t^j / factorial(j) for j = 0:big(m)])
gfperm{T<:Integer}(t, c::AbstractArray{T,1}) = prod([gfperm(t, m) for m in c])
