function test_group_multiple()
    @test multiple(ZZ(2), 5, *) == 32
    @test multiple(ArbField(53)("2.5"), 4, *) == 39.0625
    @test multiple(QQ(2),   -3, *) == 1 // ZZ(8)
    @test multiple(QQ(2),  100, +) == ZZ(2)*100
    @test multiple(QQ(2),  100, *) == ZZ(2)^100
    @test multiple(QQ(2), -100, *) == 1 // (ZZ(2)^100)
    @test multiple(ZZ(1), big(10)^1000, *) == 1

    p = nextprime(50)
    K, a = FiniteField(p, 1, "a")
    x = 5
    @test [multiple(K(x), i, +) for i in -25:25] == [mod(x*i, p) for i in -25:25]

    p = nextprime(1000)
    K, a = FiniteField(p, 1, "a")
    x, y = 5, invmod(5, p)
    @test [multiple(K(x), i, *) for i in -25:25] == [i < 0 ? powermod(y, -i, p) : powermod(x, i, p) for i in -25:25]
end

function test_group_all()
    print(rpad("Math.Algebra.Group...", 50, ' '))

    test_group_multiple()

    println("PASS")
end
