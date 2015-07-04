export
    combinations_with_repetition

# combinations{T}(a::AbstractArray{T,1}, k::Integer) = Base.combinations(a, k)

combinations_with_repetition{T}(a::AbstractArray{T,1}, k::Integer) =
    multicombinations(a, k)
