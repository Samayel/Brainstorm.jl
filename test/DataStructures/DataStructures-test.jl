module DataStructures

using Brainstorm
using Base.Test

include("Iterator-test.jl")

function test_all()
  test_iterator_all()
  println("")
end

end
