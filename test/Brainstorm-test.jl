module Test

using Brainstorm
using Base.Test

function test_dummy()
  @test 1 == 1
end

function test_all()
  test_dummy()
end

end
