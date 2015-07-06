@reexport module Combinatorics

using Brainstorm: flatten
using Brainstorm.Math.NumberTheory: expand_maclaurin_series, coefficient

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
include("combination.jl")

include("multipermutation.jl")
include("multicombination.jl")

include("subset.jl")

include("integerpartition.jl")
include("integersum.jl")

end
