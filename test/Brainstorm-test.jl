module Test

include("DataStructures/DataStructures-test.jl")
include("Math/Math-test.jl")

using Brainstorm.Test.DataStructures
using Brainstorm.Test.Math

function test_all()
  DataStructures.test_all()
  Math.test_all()
end

end
