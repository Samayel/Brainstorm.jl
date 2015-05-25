function test_primes_mfactor(fastprimes::Bool)
  @test mfactor(147573952589676412927) == @compat Dict(193707721 => 1, 761838257287 => 1)
  @test mfactor((big(2)^31-1)*(big(2)^17-1)) == @compat Dict(big(2^31-1) => 1, big(2^17-1) => 1)
  if fastprimes
    @test mfactor((big(2)^31-1)^2) == @compat Dict(big(2^31-1) => 2)
  end
end

function test_primes_nprimes()
  @test nprimes(10) == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
end

function test_primes_nthprime()
  @test nthprime(1000) == 7919
end

function test_primes_divisorsigma0()
  @test divisorsigma0(2) == 2
  @test divisorsigma0(7) == 2
  @test divisorsigma0(20) == 6
  @test divisorsigma0(99) == 6
  @test divisorsigma0(100) == 9
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

  fastprimes = false
  try
    eval(Expr(:import,:PrimeSieve))
    fastprimes = true
  catch err
  end

  test_primes_mfactor(fastprimes)
  test_primes_nprimes()
  test_primes_nthprime()
  test_primes_divisorsigma0()
  test_primes_least_number_with_d_divisors()

  println("PASS")
end
