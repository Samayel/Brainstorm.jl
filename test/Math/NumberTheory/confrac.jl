function test_confrac_iterator()
    cf = confrac(Int[])
    @test collect(cf) == []
    @test eltype(cf) == Int
    @test length(cf) == 0

    cf = confrac([1])
    @test collect(cf) == [1]
    @test eltype(cf) == Int
    @test length(cf) == 1

    cf = confrac(BigInt[1])
    @test collect(cf) == [1]
    @test eltype(cf) == BigInt
    @test length(cf) == 1

    cf = confrac([1, 2, 3, 4])
    @test collect(cf) == [1, 2, 3, 4]
    @test eltype(cf) == Int
    @test length(cf) == 4

    cf = confrac([1], 1)
    @test collect(take(cf, 3)) == [1, 1, 1]
    @test eltype(cf) == Int

    cf = confrac([1, 2, 3], 2)
    @test collect(take(cf, 5)) == [1, 2, 3, 2, 3]
    @test eltype(cf) == Int
end

function test_confrac_rationalize()
    cf = confrac(Int[])
    @test rationalize(cf) == 1 // 0
    @test rationalize(cf, 0) == 1 // 0

    cf = confrac([1])
    @test rationalize(cf) == 1
    @test rationalize(cf, 0) == 1 // 0
    @test rationalize(cf, 1) == 1

    cf = confrac([1, 2, 3, 4])
    @test rationalize(cf) == 43 // 30
    @test rationalize(cf, 0) == 1 // 0
    @test rationalize(cf, 1) == 1
    @test rationalize(cf, 2) == 3 // 2
    @test rationalize(cf, 3) == 10 // 7
    @test rationalize(cf, 4) == 43 // 30

    cf = confrac([1], 1)
    @test rationalize(cf) == 1
    @test rationalize(cf, 0) == 1 // 0
    @test rationalize(cf, 1) == 1
    @test rationalize(cf, 2) == 2
    @test rationalize(cf, 3) == 3 // 2

    cf = confrac([1, 2, 3], 2)
    @test rationalize(cf) == 10 // 7
    @test rationalize(cf, 0) == 1 // 0
    @test rationalize(cf, 1) == 1
    @test rationalize(cf, 2) == 3 // 2
    @test rationalize(cf, 3) == 10 // 7
    @test rationalize(cf, 4) == 23 // 16
    @test rationalize(cf, 5) == 79 // 55
end

function test_confrac_confrac()
    @test confrac(0 // 1) == confrac([0])

    @test confrac(3 // 7) == confrac([0, 2, 3])
    @test confrac(10 // 7) == confrac([1, 2, 3])

    @test confrac(-3 // 7) == confrac([-1, 1, 1, 3])
    @test confrac(-10 // 7) == confrac([-2, 1, 1, 3])

    @test confrac(3, 0, 7) == confrac([0, 2, 3])
    @test confrac(-3, 0, 7) == confrac([-1, 1, 1, 3])
    @test confrac(1, 4, 7) == confrac([0, 2, 3])

    @test confrac(0, 2, 1) == confrac([1, 2], 2)
    @test confrac(0, 14, 1) == confrac([3, 1, 2, 1, 6], 2)
    @test confrac(0, 19, 1) == confrac([4, 2, 1, 3, 1, 2, 8], 2)
    @test confrac(0, 42, 1) == confrac([6, 2, 12], 2)
    @test confrac(0, 48, 4) == confrac([1, 1, 2], 2)

    @test confrac(-41, 313, 36) == confrac([-1, 2, 1, 5, 8, 1, 2, 17, 2, 1, 8, 5, 1, 3, 1, 1, 2, 2, 1, 1, 3], 3)
    @test confrac(41, 313, -36) == confrac([-2, 2, 1, 2, 2, 1, 1, 3, 1, 5, 8, 1, 2, 17, 2, 1, 8, 5, 1, 3, 1], 3)
    @test confrac(-725, 313, 608) == confrac([-2, 1, 5, 8, 5, 1, 3, 1, 1, 2, 2, 1, 1, 3, 1, 5, 8, 1, 2, 17, 2, 1], 4)
    @test confrac(725, 313, -608) == confrac([-2, 1, 3, 1, 1, 17, 2, 1, 8, 5, 1, 3, 1, 1, 2, 2, 1, 1, 3, 1, 5, 8, 1, 2], 6)
end

function test_confrac_convergents()
    cf = confrac(Int[])
    @test collect(convergents(cf)) == []
    @test eltype(convergents(cf)) == Tuple{Int,Int}
    @test length(convergents(cf)) == 0

    cf = confrac([1])
    @test collect(convergents(cf)) == [(1, 1)]
    @test eltype(convergents(cf)) == Tuple{Int,Int}
    @test length(convergents(cf)) == 1

    cf = confrac(BigInt[1])
    @test collect(convergents(cf)) == [(1, 1)]
    @test eltype(convergents(cf)) == Tuple{BigInt,BigInt}
    @test length(convergents(cf)) == 1

    cf = confrac([1, 2, 3, 4])
    @test collect(convergents(cf)) == [(1, 1), (3, 2), (10, 7), (43, 30)]
    @test eltype(convergents(cf)) == Tuple{Int,Int}
    @test length(convergents(cf)) == 4

    cf = confrac([1], 1)
    @test collect(take(convergents(cf), 3)) == [(1, 1), (2, 1), (3, 2)]
    @test eltype(convergents(cf)) == Tuple{Int,Int}

    cf = confrac([1, 2, 3], 2)
    @test collect(take(convergents(cf), 5)) == [(1, 1), (3, 2), (10, 7), (23, 16), (79, 55)]
    @test eltype(convergents(cf)) == Tuple{Int,Int}
end

function test_confrac_all()
    print(rpad("Math.NumberTheory.ConFrac...", 50, ' '))

    test_confrac_iterator()
    test_confrac_rationalize()
    test_confrac_confrac()
    test_confrac_convergents()

    println("PASS")
end
