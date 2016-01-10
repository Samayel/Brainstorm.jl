function test_field_root()
    K, a = FiniteField(31, 1, "a")
    @test root(K(22), 7) == 13
    @test root(K(25), 5) == 5
    @test root(K(23), 3) == 29
    @test root(K(1),  2) == 30
    @test root(K(1),  5) == 16
    @test root(K(1),  7) == 1

    K, a = FiniteField(5, 4, "a")
    @test root(3a^2 + a + 1, 13)^13 == 3a^2 + a + 1

    K, a = FiniteField(29, 2, "a")
    b = a^2 + 5a + 1
    @test                       root(b, 11) == 3a + 20
    @test_throws ErrorException root(b,  5)
    @test                       root(b,  3) == 14a + 18

    K, a = FiniteField(29, 5, "a")
    b = a^2 + 5a + 1
    @test                       root(b, 5) == 19a^4 + 2a^3 + 2a^2 + 16a + 3
    @test_throws ErrorException root(b, 7)
    @test_throws ErrorException root(b, 4)

    for p in [2, 3, 5, 7, 11]
        for n in [2, 5, 10]
            q = p^n
            K, a = FiniteField(p, n, "a")

            for r in factors(q-1)
                r == 1 && continue
                x = rand(K)
                y = x^r

                @test root(y,        r)^r      == y
                @test root(y^41,   41r)^(41r)  == y^41
                @test root(y^307, 307r)^(307r) == y^307
            end
        end
    end

    K, a = FiniteField(13, 1, "a")
    b = zero(K)
    @test_throws DomainError root(b, -2)
    @test_throws DomainError root(b, -1)
    @test_throws DomainError root(b,  0)
    @test                    root(b,  1) == b
    @test                    root(b,  2) == b

    @test root(K(3), -1) == root(K( 9), 1)
    @test root(K(3), -2) == root(K( 9), 2)
    @test root(K(4), -1) == root(K(10), 1)
    @test root(K(4), -2) == root(K(10), 2)

    @test_throws DomainError root(K(-2), 0)
    @test_throws DomainError root(K(-1), 0)
    @test                    root(K( 1), 0) == 1
    @test_throws DomainError root(K( 2), 0)
end

function test_field_roots()
    K, a = FiniteField(31, 1, "a")
    @test roots(K(22), 7) == [13]
    @test roots(K(25), 5) == [5,18,9,20,10]
    @test roots(K(23), 3) == [29,12,21]
    @test roots(K(1),  2) == [1,30]
    @test roots(K(1),  5) == [1,16,8,4,2]
    @test roots(K(1),  7) == [1]

    K, a = FiniteField(5, 4, "a")
    @test roots(3a^2 + a + 1, 13) == [4a^2+3a+3, 4a^3+3a^2+1, 4a^3+2a^2+a+2, 4a, 3a^3+2a^2+4, 2a+1, a^3+3a^2+a, 3a^3+3a+3, 3a^3+3a^2+4, 3a^3+2a^2+2, a^3+a^2, 3a^2+2a, 3a^3+2a^2+4a]

    K, a = FiniteField(29, 2, "a")
    b = a^2 + 5a + 1
    @test roots(b, 11) == [3a + 20]
    @test roots(b,  5) == []
    @test roots(b,  3) == [14a+18, 10a+13, 5a+27]

    K, a = FiniteField(29, 5, "a")
    b = a^2 + 5a + 1
    @test roots(b, 5) == [19a^4 + 2a^3 + 2a^2 + 16a + 3]
    @test roots(b, 7) == []
    @test roots(b, 4) == []

    K, a = FiniteField(13, 1, "a")
    b = zero(K)
    @test_throws DomainError roots(b, -2)
    @test_throws DomainError roots(b, -1)
    @test_throws DomainError roots(b,  0)
    @test                    roots(b,  1) == [b]
    @test                    roots(b,  2) == [b]

    @test roots(K(3), -1) == roots(K( 9), 1)
    @test roots(K(3), -2) == roots(K( 9), 2)
    @test roots(K(4), -1) == roots(K(10), 1)
    @test roots(K(4), -2) == roots(K(10), 2)

    @test_throws DomainError roots(K(-2), 0)
    @test_throws DomainError roots(K(-1), 0)
    @test                    roots(K( 1), 0) == [1,2,4,8,3,6,12,11,9,5,10,7]
    @test_throws DomainError roots(K( 2), 0)

    K, a = FiniteField(3, 2, "a")
    @test roots(K(1), 0) == [0a+1,a,a+1,2a+1,0a+2,2a,2a+2,a+2]
end

function test_field_all()
    print(rpad("Math.Algebra.Field...", 50, ' '))

    test_field_root()
    test_field_roots()

    println("PASS")
end
