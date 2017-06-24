
# combinations(a, k) = Combinatorics.combinations(a, k)

Combinatorics.combinations(a, k::Integer, ::Type{Val{:unique}}) = combinations(a, k)
Combinatorics.combinations(a, k::Integer, ::Type{Val{:repeated}}) = multicombinations(a, k)
