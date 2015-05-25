module Math

using Brainstorm
using Base.Test

include("Checked-test.jl")

include("NumberTheory/NumberTheory-test.jl")
using Brainstorm.Test.Math.NumberTheory

function test_all()
  test_checked_all()
  println("")

  NumberTheory.test_all()
end

end
