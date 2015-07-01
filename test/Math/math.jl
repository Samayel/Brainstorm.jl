module Math

using Brainstorm.Math
using Base.Test

include("NumberTheory/numbertheory.jl")
include("combinatorics.jl")

function test_all()
    println("")
    NumberTheory.test_all()
    test_combinatorics_all()
end

end
