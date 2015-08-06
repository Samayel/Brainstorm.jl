function test_pentagon_ispentagonal()
    @test find([ispentagonal(i) for i = 1:1000]) == [1, 5, 12, 22, 35, 51, 70, 92, 117, 145, 176, 210, 247, 287, 330, 376, 425, 477, 532, 590, 651, 715, 782, 852, 925]
end

function test_pentagon_nthpentagonal()
    @test nthpentagonal(1) == 1
    @test nthpentagonal(2) == 5
    @test nthpentagonal(10) == 145
end

function test_pentagon_npentagonal()
    @test npentagonal(10) == [1, 5, 12, 22, 35, 51, 70, 92, 117, 145]
    @test eltype(npentagonal(10)) == Int
    @test eltype(npentagonal(10, BigInt)) == BigInt
end

function test_pentagon_somepentagonal()
    @test collect(somepentagonal(91)) == [1, 5, 12, 22, 35, 51, 70]
    @test collect(somepentagonal(92)) == [1, 5, 12, 22, 35, 51, 70, 92]
    @test eltype(somepentagonal(92)) == Int
    @test eltype(somepentagonal(big(92))) == BigInt
end

function test_pentagon_exactpentagonal()
    @test collect(exactpentagonal(10)) == [1, 5, 12, 22, 35, 51, 70, 92, 117, 145]
    @test eltype(exactpentagonal(10)) == Int
    @test eltype(exactpentagonal(10, BigInt)) == BigInt
end

function test_pentagon_all()
    print(rpad("Math.NumberTheory.Pentagon...", 50, ' '))

    test_pentagon_ispentagonal()
    test_pentagon_nthpentagonal()
    test_pentagon_npentagonal()
    test_pentagon_somepentagonal()
    test_pentagon_exactpentagonal()

    println("PASS")
end
