@reexport module Combinatorics

using Brainstorm: flatten

@reexport using Multicombinations

export
    multinomial

# Multinomial coefficient where n = sum(k)
# https://github.com/jiahao/Combinatorics.jl/blob/master/src/Combinatorics.jl
multinomial(k...) = begin
    s = 0
    result = 1
    for i in k
        s += i
        result *= binomial(s, i)
    end
    result
end

include("permutation.jl")
include("variation.jl")
include("combination.jl")

include("permutationmultiset.jl")

# TODO: k-combinations of multisets
# TODO: Iterator.subsets()

end
