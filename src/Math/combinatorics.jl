
VERSION < v"0.4-" && @reexport using Combinatorics
@reexport using Multicombinations

export
    permutations_with_repetitions,
#   variations, variations_with_repetitions,
    combinations_with_repetitions


# Base.permutations()

permutations_with_repetitions{T}(a::AbstractArray{T,1}) =
    variations_with_repetitions(a, length(a))


# http://www.aconnect.de/friends/editions/computer/combinatoricode_e.html
#variations{T}(a::AbstractArray{T,1}, k::Integer) = nothing

# product(repeated(a, k)...)
#variations_with_repetitions{T}(a::AbstractArray{T,1}, k::Integer) = nothing

# Base.combinations()

combinations_with_repetitions{T}(a::AbstractArray{T,1}, k::Integer) =
    multicombinations(a, k)
