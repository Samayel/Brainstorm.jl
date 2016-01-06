module Algebra

using Base.Test
using Brainstorm

function test_field_root()
    K, a = FiniteField(31, 1, "a")
    @test root(K(22), 7) == 13
    @test root(K(25), 5) == 5
    @test root(K(23), 3) == 29
    @test root(K(1), 2) == 30
    @test root(K(1), 5) == 16
    @test root(K(1), 7) == 1

    K, a = FiniteField(5, 4, "a")
    @test root(3a^2 + a + 1, 13)^13 == 3a^2 + a + 1

    K, a = FiniteField(29, 2, "a")
    b = a^2 + 5a + 1
    @test root(b, 11) == 3a + 20
    @test_throws ErrorException root(b, 5)
    @test root(b, 3) == 14a + 18

    K, a = FiniteField(29, 5, "a")
    b = a^2 + 5a + 1
    @test root(b, 5) == 19a^4 + 2a^3 + 2a^2 + 16a + 3
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
end

function test_all()
    print(rpad("Math.Algebra...", 50, ' '))

    test_field_root()

    println("PASS")
end

end
