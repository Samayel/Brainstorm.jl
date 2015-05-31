module Math

using Brainstorm.Math
using Base.Test

include("Intervals-test.jl")
include("NumberTheory/NumberTheory-test.jl")

function test_all()
  println("")
  test_intervals_all()
  NumberTheory.test_all()
end

end
