module Math

include("NumberTheory/NumberTheory-test.jl")

using Brainstorm.Test.Math.NumberTheory

function test_all()
  NumberTheory.test_all()
end

end
