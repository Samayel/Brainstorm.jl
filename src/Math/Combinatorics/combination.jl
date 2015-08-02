
# combinations(a, k) = Base.combinations(a, k)

Base.combinations{T}(a::AbstractArray{T,1}, k::Integer, mode::Symbol) = begin
    mode ∈ [:unique, :repeated] || error("Mode must be :unique or :repeated")
    mode == :repeated ?
        multicombinations(a, k) :
        combinations(a, k)
end
