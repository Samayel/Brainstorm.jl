
# permutations(a) = Combinatorics.permutations(a)

Combinatorics.permutations(a, mode::Type{Val{:unique}}) = permutations(a, length(a), mode)
Combinatorics.permutations(a, mode::Type{Val{:repeated}}) = permutations(a, length(a), mode)
Combinatorics.permutations(a::T, k::Integer, ::Type{Val{:unique}}) where {T} = Permutations{T, Val{:unique}}(a, k)
Combinatorics.permutations(a::T, k::Integer, ::Type{Val{:repeated}}) where {T} = Permutations{T, Val{:repeated}}(a, k)

struct Permutations{T,M}
    a::T
    k::Int
end

Base.start(v::Permutations{T, Val{:unique}}) where {T} = v.k <= length(v.a) ? collect(1:v.k) : [length(v.a) + 1]
Base.start(v::Permutations{T, Val{:repeated}}) where {T} = ones(Int, v.k)

Base.next(v::Permutations{T,M}, s) where {T,M} = begin
    permutation = [v.a[si] for si in s]
    v.k > 0 || return permutation, [length(v.a) + 1]

    s = copy(s)
    for i in length(s):-1:1
        next!(v, s, i)

        if s[i] <= length(v.a)
            s[i+1:end] = tail(v, s, i)
            break
        end
    end

    permutation, s
end

next!(::Permutations{T, Val{:unique}}, s, i) where {T} = begin
    s[i] += 1
    while s[i] ∈ s[1:i-1]
        s[i] += 1
    end
end
next!(::Permutations{T, Val{:repeated}}, s, i) where {T} = s[i] += 1

tail(v::Permutations{T, Val{:unique}}, s, i) where {T} = setdiff(collect(1:v.k), s[1:i])[1:(length(s)-i)]
tail(::Permutations{T, Val{:repeated}}, s, i) where {T} = ones(Int, length(s) - i)

Base.done(v::Permutations, s) = !isempty(s) && s[1] > length(v.a)

Base.eltype(v::Permutations) = eltype(typeof(v))
Base.eltype(::Type{Permutations{T,M}}) where {T,M} = Array{eltype(T),1}

Base.length(v::Permutations{T, Val{:unique}}) where {T} = begin
    v.k <= length(v.a) || return big(0)
    factorial(big(length(v.a)), length(v.a) - v.k)
end
Base.length{T}(v::Permutations{T, Val{:repeated}}) = big(length(v.a))^v.k
