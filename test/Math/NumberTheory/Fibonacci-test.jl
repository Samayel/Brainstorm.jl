function test_fibonacci_nthfibonacci()
    @test nthfibonacci(1) == 1
    @test nthfibonacci(2) == 1
    @test nthfibonacci(10) == 55

    @test nthfibonacci(91, Int64) == 4660046610375530309
    # @test nthfibonacci(92, Int64) => v0.3 ok; v0.4 overflow
    @test_throws OverflowError nthfibonacci(93, Int64)

    @test nthfibonacci(184, Int128) == 127127879743834334146972278486287885163
    # checked ops are broken for 128-bit types (LLVM bug) ## FIXME: #4905
    #@test_throws OverflowError nthfibonacci(185, Int128)

    @test nthfibonacci(200, BigInt) == 280571172992510140037611932413038677189525
end

function test_fibonacci_nfibonacci()
    @test nfibonacci(10) == [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
    @test eltype(nfibonacci(10)) == typeof(1)
end

function test_fibonacci_somefibonacci()
    @test collect(somefibonacci(34)) == [1, 1, 2, 3, 5, 8, 13, 21, 34]
    @test collect(somefibonacci(39, 13, -5)) == [13, -5, 8, 3, 11, 14, 25, 39]
    @test eltype(somefibonacci(34)) == typeof(1)
    @test eltype(somefibonacci(39, 13, -5)) == typeof(13)
end

function test_fibonacci_exactfibonacci()
    @test collect(exactfibonacci(5)) == [1, 1, 2, 3, 5]
    @test collect(exactfibonacci(5, 13, -5)) == [13, -5, 8, 3, 11]
    @test eltype(exactfibonacci(5)) == typeof(1)
    @test eltype(exactfibonacci(5, 13, -5)) == typeof(13)
end

function test_fibonacci_all()
    print("Math.NumberTheory.Fibonacci... ")

    test_fibonacci_nthfibonacci()
    test_fibonacci_nfibonacci()
    test_fibonacci_somefibonacci()
    test_fibonacci_exactfibonacci()

    println("PASS")
end
