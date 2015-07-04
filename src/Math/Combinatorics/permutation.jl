export
    permutations_with_repetition

# permutations{T}(a::AbstractArray{T,1}) = Base.permutations(a)

permutations_with_repetition{T}(a::AbstractArray{T,1}) =
    variations_with_repetition(a, length(a))
