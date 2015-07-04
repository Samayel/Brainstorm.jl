
@reexport using Multicombinations

export
    multinomial,
    permutations_with_repetition,
    variations, variations_with_repetition,
    combinations_with_repetition,
    permutations_of_multiset


# Multinomial coefficient where n = sum(k)
# https://github.com/jiahao/Combinatorics.jl/blob/master/src/Combinatorics.jl
multinomial(k...) = begin
    s = 0
    result = 1
    for i in k
        s += i
        result *= binomial(s, i)
    end
    result
end


# TODO: k-combinations of multisets
# TODO: Iterator.subsets()

###
### permutations
###

# permutations{T}(a::AbstractArray{T,1}) = Base.permutations(a)

permutations_with_repetition{T}(a::AbstractArray{T,1}) =
    variations_with_repetition(a, length(a))


###
### variations (k-permutations)
###

variations{T}(a::AbstractArray{T,1}, k::Integer) = Variations(a, k, false)
variations_with_repetition{T}(a::AbstractArray{T,1}, k::Integer) = Variations(a, k, true)

immutable Variations{T}
    a::T
    k::Int
    repetition::Bool
end

Base.start(v::Variations) = begin
    v.repetition && return ones(Int, v.k)
    v.k <= length(v.a) ? collect(1:v.k) : [length(v.a) + 1]
end

Base.next(v::Variations, s) = begin
    variation = [v.a[si] for si in s]
    v.k > 0 || return (variation, [length(v.a) + 1])

    s = copy(s)
    for i = length(s):-1:1
        s[i] += 1
        v.repetition || (while s[i] ∈ s[1:i-1]; s[i] += 1; end)

        if s[i] <= length(v.a)
            s[i+1:end] = v.repetition ?
                ones(Int, length(s) - i) :
                setdiff(collect(1:v.k), s[1:i])[1:(length(s)-i)]
            break
        end
    end

    (variation, s)
end

Base.done(v::Variations, s) = !isempty(s) && s[1] > length(v.a)

Base.eltype(v::Variations) = eltype(typeof(v))
Base.eltype{T}(::Type{Variations{T}}) = Array{eltype(T),1}

Base.length(v::Variations) = begin
    v.repetition && return length(v.a)^v.k
    v.k <= length(v.a) || return 0
    factorial(length(v.a), length(v.a) - v.k)
end


###
### (k-)combinations [subsets and multisubsets]
###

# combinations{T}(a::AbstractArray{T,1}, k::Integer) = Base.combinations(a, k)

combinations_with_repetition{T}(a::AbstractArray{T,1}, k::Integer) =
    multicombinations(a, k)


###
### k-permutations of multiset
###

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
