
# combinations(a, k) = Base.combinations(a, k)

Base.combinations(a, k::Integer, ::Type{Val{:unique}}) = combinations(a, k)
Base.combinations(a, k::Integer, ::Type{Val{:repeated}}) = multicombinations(a, k)
