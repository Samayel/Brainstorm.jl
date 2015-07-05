module Combinatorics

using Brainstorm.Math.Combinatorics
using Base.Test

include("permutation.jl")
include("combination.jl")
include("multipermutation.jl")

function test_all()
    test_permutation_all()
    test_combination_all()
    test_multipermutation_all()
end

end
