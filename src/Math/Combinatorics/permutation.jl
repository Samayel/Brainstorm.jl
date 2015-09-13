
# permutations(a) = Base.permutations(a)

Base.permutations{T}(a::AbstractArray{T,1}, mode::Val{:unique}) = permutations(a, length(a), mode)
Base.permutations{T}(a::AbstractArray{T,1}, mode::Val{:repeated}) = permutations(a, length(a), mode)
Base.permutations{T}(a::AbstractArray{T,1}, k::Integer, ::Val{:unique}) = Permutations(a, k, false)
Base.permutations{T}(a::AbstractArray{T,1}, k::Integer, ::Val{:repeated}) = Permutations(a, k, true)

immutable Permutations{T}
    a::T
    k::Int
    repeated::Bool
end

Base.start(v::Permutations) = begin
    v.repeated && return ones(Int, v.k)
    v.k <= length(v.a) ? collect(1:v.k) : [length(v.a) + 1]
end

Base.next(v::Permutations, s) = begin
    permutation = [v.a[si] for si in s]
    v.k > 0 || return (permutation, [length(v.a) + 1])

    s = copy(s)
    for i = length(s):-1:1
        s[i] += 1
        v.repeated || (while s[i] ∈ s[1:i-1]; s[i] += 1; end)

        if s[i] <= length(v.a)
            s[i+1:end] = v.repeated ?
                ones(Int, length(s) - i) :
                setdiff(collect(1:v.k), s[1:i])[1:(length(s)-i)]
            break
        end
    end

    (permutation, s)
end

Base.done(v::Permutations, s) = !isempty(s) && s[1] > length(v.a)

Base.eltype(v::Permutations) = eltype(typeof(v))
Base.eltype{T}(::Type{Permutations{T}}) = Array{eltype(T),1}

Base.length(v::Permutations) = begin
    v.repeated && return length(v.a)^v.k
    v.k <= length(v.a) || return 0
    factorial(length(v.a), length(v.a) - v.k)
end
