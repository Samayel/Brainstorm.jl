module DataStructures

using Brainstorm.DataStructures
using Base.Test

include("Iterators-test.jl")

function test_all()
  println("")
  test_iterators_all()
end

end
