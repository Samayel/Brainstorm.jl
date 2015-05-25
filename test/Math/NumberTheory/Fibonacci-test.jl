function test_fibonacci_nthfibonacci()
  @test nthfibonacci(1) == 1
  @test nthfibonacci(2) == 1
  @test nthfibonacci(10) == 55

  @test nthfibonacci(91, Int64) == 4660046610375530309
  @test_throws OverflowError nthfibonacci(92, Int64)

  @test nthfibonacci(183, Int128) == 78569350599398894027251472817058687522
  @test_throws OverflowError nthfibonacci(184, Int128)

  @test nthfibonacci(200, BigInt) == 280571172992510140037611932413038677189525
end

function test_fibonacci_nfibonacci()
  @test nfibonacci(10) == [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
end

function test_fibonacci_somefibonacci()
  @test collect(somefibonacci(50)) == [1, 1, 2, 3, 5, 8, 13, 21, 34]
  @test collect(somefibonacci(50, 13, -5)) == [13, -5, 8, 3, 11, 14, 25, 39]
end

function test_fibonacci_exactfibonacci()
  @test collect(exactfibonacci(5)) == [1, 1, 2, 3, 5]
  @test collect(exactfibonacci(5, 13, -5)) == [13, -5, 8, 3, 11]
end

function test_fibonacci_all()
  print("Math.NumberTheory.Fibonacci...")

  test_fibonacci_nthfibonacci()
  test_fibonacci_nfibonacci()
  test_fibonacci_somefibonacci()
  test_fibonacci_exactfibonacci()

  println("PASS")
end
