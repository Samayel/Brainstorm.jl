function test_primes_mfactor()
  @test mfactor(147573952589676412927) == @compat Dict(193707721 => 1, 761838257287 => 1)
  @test mfactor((big(2)^31-1)*(big(2)^17-1)) == @compat Dict(big(2^31-1) => 1, big(2^17-1) => 1)
  if fastprimes()
    @test mfactor((big(2)^31-1)^2) == @compat Dict(big(2^31-1) => 2)
  end
end

function test_primes_nprimes()
  @test nprimes(10) == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
end

function test_primes_nthprime()
  @test nthprime(1000) == 7919
end

function test_primes_divisorsigma()
  @test divisorsigma(1) == 1
  @test divisorsigma(2) == 3
  @test divisorsigma(7) == 8
  @test divisorsigma(20) == 42
  @test divisorsigma(99) == 156
  @test divisorsigma(100) == 217

  @test_throws DomainError divisorsigma(1, -1)

  @test divisorsigma(1, 0) == 1
  @test divisorsigma(2, 0) == 2
  @test divisorsigma(7, 0) == 2
  @test divisorsigma(20, 0) == 6
  @test divisorsigma(99, 0) == 6
  @test divisorsigma(100, 0) == 9

  @test divisorsigma(1, 1) == 1
  @test divisorsigma(2, 1) == 3
  @test divisorsigma(7, 1) == 8
  @test divisorsigma(20, 1) == 42
  @test divisorsigma(99, 1) == 156
  @test divisorsigma(100, 1) == 217

  @test divisorsigma(1, 2) == 1
  @test divisorsigma(2, 2) == 5
  @test divisorsigma(7, 2) == 50
  @test divisorsigma(20, 2) == 546
  @test divisorsigma(99, 2) == 11102
  @test divisorsigma(100, 2) == 13671
end

function test_primes_least_number_with_d_divisors()
  @test least_number_with_d_divisors(16) == 120
  @test least_number_with_d_divisors(240) == 720720
  @test least_number_with_d_divisors(4000) == 261891630000
  @test least_number_with_d_divisors(4001) == big(2)^4000
  @test least_number_with_d_divisors(4002) == 1474163083033391923200
end

function test_primes_all()
  print("Math.NumberTheory.Primes...")

  test_primes_mfactor()
  test_primes_nprimes()
  test_primes_nthprime()
  test_primes_divisorsigma()
  test_primes_least_number_with_d_divisors()

  println("PASS")
end
