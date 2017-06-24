
# permutations(a) = Combinatorics.permutations(a)

Combinatorics.permutations(a, mode::Type{Val{:unique}}) = permutations(a, length(a), mode)
Combinatorics.permutations(a, mode::Type{Val{:repeated}}) = permutations(a, length(a), mode)
Combinatorics.permutations{T}(a::T, k::Integer, ::Type{Val{:unique}}) = Permutations{T, Val{:unique}}(a, k)
Combinatorics.permutations{T}(a::T, k::Integer, ::Type{Val{:repeated}}) = Permutations{T, Val{:repeated}}(a, k)

immutable Permutations{T,M}
    a::T
    k::Int
end

Base.start{T}(v::Permutations{T, Val{:unique}}) = v.k <= length(v.a) ? collect(1:v.k) : [length(v.a) + 1]
Base.start{T}(v::Permutations{T, Val{:repeated}}) = ones(Int, v.k)

Base.next{T,M}(v::Permutations{T,M}, s) = begin
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

next!{T}(::Permutations{T, Val{:unique}}, s, i) = begin
    s[i] += 1
    while s[i] ∈ s[1:i-1]
        s[i] += 1
    end
end
next!{T}(::Permutations{T, Val{:repeated}}, s, i) = s[i] += 1

tail{T}(v::Permutations{T, Val{:unique}}, s, i) = setdiff(collect(1:v.k), s[1:i])[1:(length(s)-i)]
tail{T}(::Permutations{T, Val{:repeated}}, s, i) = ones(Int, length(s) - i)

Base.done(v::Permutations, s) = !isempty(s) && s[1] > length(v.a)

Base.eltype(v::Permutations) = eltype(typeof(v))
Base.eltype{T,M}(::Type{Permutations{T,M}}) = Array{eltype(T),1}

Base.length{T}(v::Permutations{T, Val{:unique}}) = begin
    v.k <= length(v.a) || return big(0)
    factorial(big(length(v.a)), length(v.a) - v.k)
end
Base.length{T}(v::Permutations{T, Val{:repeated}}) = big(length(v.a))^v.k
