module DataStructure

using Brainstorm.DataStructure
using Base.Test

include("Iterators-test.jl")
include("Matrix-test.jl")

function test_all()
    println("")
    test_iterators_all()
    test_matrix_all()
end

end
