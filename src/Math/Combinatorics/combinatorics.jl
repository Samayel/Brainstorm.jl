@reexport module Combinatorics

export multinomial

using Brainstorm: flatten
using Nemo: QQ, ZZ, PowerSeriesRing, coeff, divexact, fac
using Combinatorics: factorial
using Multicombinations: multicombinations

# Multinomial coefficient where n = sum(k)
# https://github.com/jiahao/Combinatorics.jl/blob/master/src/Combinatorics.jl
multinomial(k) = begin
    s = big(0)
    result = big(1)
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
