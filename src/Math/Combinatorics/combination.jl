
# combinations(a, k) = Base.combinations(a, k)

Base.combinations{T}(a::AbstractArray{T,1}, k::Integer, ::Val{:unique}) = combinations(a, k)
Base.combinations{T}(a::AbstractArray{T,1}, k::Integer, ::Val{:repeated}) = multicombinations(a, k)
