export
    permutations_of_multiset

permutations_of_multiset{T,U<:Integer}(a::AbstractArray{T,1}, c::AbstractArray{U,1}) =
    MultisetPermuations(a, c)

permutations_of_multiset{T,U<:Integer}(a::AbstractArray{T,1}, c::AbstractArray{U,1}, k::Integer) =
    MultisetKPermuations(a, c, k)

abstract AbstractMultisetPermuations{T,U}

immutable MultisetPermuations{T,U} <: AbstractMultisetPermuations{T,U}
    a::T
    c::U
end

immutable MultisetKPermuations{T,U} <: AbstractMultisetPermuations{T,U}
    a::T
    c::U
    k::Int
end

getk(p::MultisetPermuations) = sum(p.c)
getk(p::MultisetKPermuations) = p.k

Base.start(p::AbstractMultisetPermuations) = begin
    s = [fill(i, p.c[i]) for i = 1:length(p.a)] |> flatten
    k = getk(p)
    k <= length(s) ? s[1:k] : [length(p.a) + 1]
end

Base.next(p::AbstractMultisetPermuations, s) = begin
    variation = [p.a[si] for si in s]
    getk(p) > 0 || return (variation, [length(p.a) + 1])

    s = copy(s)
    for i = length(s):-1:1
        s[i] += 1
        while s[i] <= length(p.a) && countnz(s .== s[i]) > p.c[s[i]]
            s[i] += 1
        end

        if s[i] <= length(p.a)
            t = [fill(i, p.c[i] - countnz(s .== i)) for i = 1:length(p.a)] |> flatten
            s[i+1:end] = t[1:(length(s)-i)]
            break
        end
    end

    (variation, s)
end

Base.done(p::AbstractMultisetPermuations, s) = !isempty(s) && s[1] > length(p.a)

Base.eltype(p::AbstractMultisetPermuations) = eltype(typeof(p))
Base.eltype{T,U}(::Type{MultisetPermuations{T,U}}) = Array{eltype(T),1}
Base.eltype{T,U}(::Type{MultisetKPermuations{T,U}}) = Array{eltype(T),1}

Base.length(p::MultisetPermuations) = multinomial(p.c...)

# TODO
#   - https://mathoverflow.net/questions/33273/combinations-of-multisets-with-finite-multiplicities
#   - http://www.m-hikari.com/ams/ams-2011/ams-17-20-2011/siljakAMS17-20-2011.pdf
# Base.length(p::MultisetKPermuations) = ???
