export Permutation, swap!, apply

@auto_hash_equals immutable Permutation{n}
    perm::Vector{Int}
    Permutation{n}(perm) where {n} = begin
        length(perm) == n || error("Dimension mismatch")
        new(perm)
    end
end

Permutation(perm::Vector{Int}) = Permutation{length(perm)}(perm)

one(::Type{Permutation{n}}) where {n} = Permutation(collect(1:n))
one(p::Permutation) = one(typeof(p))

getindex(p::Permutation, i::Int) = p.perm[i]

inv(p::Permutation{n}) where {n} = begin
    perm = zeros(Int, n)
    for i in 1:n
        perm[p[i]] = i
    end
    Permutation(perm)
end

swap!(p::Permutation, i::Integer, j::Integer) = (t = p.perm[i]; p.perm[i] = p.perm[j]; p.perm[j] = t)
circshift!(p::Permutation, k::Integer) = (t = copy(p.perm); circshift!(p.perm, t, k))

apply(p::Permutation, x) = x[p.perm]

*(p::Permutation{n}, q::Permutation{n}) where {n} = Permutation([p[q[i]] for i in 1:n])
^(p::Permutation, k::Integer) = begin
    res, a = one(p), p
    while k > 0
        k & 1 == 1 && (res *= a)
        a *= a
        k >>= 1
    end
    res
end
