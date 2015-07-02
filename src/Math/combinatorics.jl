
VERSION < v"0.4-" && @reexport using Combinatorics
@reexport using Multicombinations

export
    permutations_with_repetitions,
    variations, variations_with_repetitions,
    combinations_with_repetitions


# permutations{T}(a::AbstractArray{T,1}) = Base.permutations(a)

permutations_with_repetitions{T}(a::AbstractArray{T,1}) =
    variations_with_repetitions(a, length(a))


# http://www.aconnect.de/friends/editions/computer/combinatoricode_e.html
variations{T}(::AbstractArray{T,1}, ::Integer) = nothing

variations_with_repetitions{T}(a::AbstractArray{T,1}, k::Integer) =
    @pipe product(repeated(a, k)...) |>            # cartesian product as tuples
    tmap(t -> [t[end:-1:1]...], Array{T,1}, _)     # convert tuples to arrays


# combinations{T}(a::AbstractArray{T,1}, k::Integer) = Base.combinations(a, k)

combinations_with_repetitions{T}(a::AbstractArray{T,1}, k::Integer) =
    multicombinations(a, k)
