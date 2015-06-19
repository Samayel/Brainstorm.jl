module Math

using Brainstorm.Math
using Base.Test

include("NumberTheory/NumberTheory-test.jl")

function test_all()
    println("")
    NumberTheory.test_all()
end

end
