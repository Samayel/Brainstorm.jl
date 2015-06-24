module Math

using Brainstorm.Math
using Base.Test

include("NumberTheory/numbertheory.jl")

function test_all()
    println("")
    NumberTheory.test_all()
end

end
