
# combinations{T}(a::AbstractArray{T,1}, k::Integer) = Base.combinations(a, k)

Base.combinations{T}(a::AbstractArray{T,1}, k::Integer, mode::Symbol) =
    mode == :repetition ?
        multicombinations(a, k) :
        combinations(a, k)
