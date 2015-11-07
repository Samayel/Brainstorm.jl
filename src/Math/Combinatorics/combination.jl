
# combinations(a, k) = Base.combinations(a, k)

Base.combinations(a, k, ::Type{Val{:unique}}) = combinations(a, k)
Base.combinations(a, k, ::Type{Val{:repeated}}) = multicombinations(a, k)
