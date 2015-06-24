module DataStructure

using Brainstorm.DataStructure
using Base.Test

include("iterator.jl")
include("matrix.jl")

function test_all()
    println("")
    test_iterator_all()
    test_matrix_all()
end

end
