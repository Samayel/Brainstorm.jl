module DataStructure

import Brainstorm

using Brainstorm.DataStructure
using Base.Test

include("iterator.jl")
include("vector.jl")
include("matrix.jl")
include("intset.jl")

function test_all()
    println("")
    test_iterator_all()
    test_vector_all()
    test_matrix_all()
    test_intset_all()
end

end
