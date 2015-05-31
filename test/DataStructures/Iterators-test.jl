function test_iterators_takewhile()
  @test collect(takewhile(1:10, x -> x^2 < 1)) == []
  @test collect(takewhile(1:10, x -> x^2 < 25)) == [1, 2, 3, 4]
  @test collect(takewhile(1:10, x -> x^2 < 1000)) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
end

function test_iterators_dropwhile()
  @test collect(dropwhile(1:10, x -> x^2 < 1)) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  @test collect(dropwhile(1:10, x -> x^2 < 25)) == [5, 6, 7, 8, 9, 10]
  @test collect(dropwhile(1:10, x -> x^2 < 1000)) == []
end

function test_iterators_all()
  print("DataStructures.Iterators... ")

  test_iterators_takewhile()
  test_iterators_dropwhile()

  println("PASS")
end
