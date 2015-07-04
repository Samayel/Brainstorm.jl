module Math

using Base.Test

include("NumberTheory/numbertheory.jl")
include("Combinatorics/combinatorics.jl")

function test_all()
    println("")
    NumberTheory.test_all()
    println("")
    Combinatorics.test_all()
end

end
