module Math

using Brainstorm
using Base.Test

include("Intervals-test.jl")

include("NumberTheory/NumberTheory-test.jl")
using Brainstorm.Test.Math.NumberTheory

function test_all()
  test_intervals_all()

  NumberTheory.test_all()
end

end
