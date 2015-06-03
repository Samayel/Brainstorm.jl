module Test

include("DataStructures/DataStructures-test.jl")
include("Math/Math-test.jl")
include("Meta/Meta-test.jl")

function test_all()
  DataStructures.test_all()
  Math.test_all()
  Meta.test_all()
end

end
