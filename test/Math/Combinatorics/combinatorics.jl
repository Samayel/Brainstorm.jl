module _Combinatorics

using Brainstorm._Math._Combinatorics
using Base.Test

include("permutation.jl")
include("combination.jl")
include("multipermutation.jl")
include("multicombination.jl")

function test_all()
    test_permutation_all()
    test_combination_all()
    test_multipermutation_all()
    test_multicombination_all()
end

end
