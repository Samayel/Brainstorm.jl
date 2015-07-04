export
    variations, variations_with_repetition

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
