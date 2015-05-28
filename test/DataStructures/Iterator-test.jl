function test_iterator_takewhile()
  @test collect(takewhile(1:10, x -> x^2 < 1)) == []
  @test collect(takewhile(1:10, x -> x^2 < 25)) == [1, 2, 3, 4]
  @test collect(takewhile(1:10, x -> x^2 < 1000)) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
end

function test_iterator_all()
  print("DataStructures.Iterator...")

  test_iterator_takewhile()

  println("PASS")
end
