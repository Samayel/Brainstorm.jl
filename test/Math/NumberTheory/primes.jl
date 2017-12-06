
function test_primes_coprime()
    @test coprime(1, 3) == true
    @test coprime(2, 3) == true
    @test coprime(11*13*17, 13*17*19) == false
    @test coprime(2*3, 5*7) == true
end

function test_primes_all()
    label = "Math.NumberTheory.Primes..."
    print(rpad(label, 50, ' '))

    test_primes_coprime()

    println("PASS")
end
