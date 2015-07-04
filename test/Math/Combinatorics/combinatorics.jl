module Combinatorics

using Brainstorm.Math.Combinatorics
using Base.Test

include("permutation.jl")
include("variation.jl")
include("combination.jl")
include("permutationmultiset.jl")

function test_all()
    test_permutation_all()
    test_variation_all()
    test_combination_all()
    test_permutationmultiset_all()
end

end
