using Brainstorm
using Base.Test

function test_iterator_takewhile()
  @test collect(takewhile(1:10, x -> x^2 < 25)) == [1, 2, 3, 4]
end

function test_iterator_takeuntil()
  @test collect(takeuntil(1:10, x -> x^2 >= 25)) == [1, 2, 3, 4, 5]
end

function test_iterator_all()
  print("DataStructures.Iterator...")

  test_iterator_takewhile()
  test_iterator_takeuntil()

  println("PASS")
end
