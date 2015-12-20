module EllipticCurves

using Base.Test
using Brainstorm.Math

function test_wnf_QQ()
    c = curve(big(-2//1), big(4//1))
    p = point(c, 3, 5)
    q = point(c, -2, 0)

    @test p-q == point(c, 0, -2)
    @test p+p+p+p+p == point(c, 2312883//1142761, -3507297955//1221611509)
    @test 5p == point(c, 2312883//1142761, -3507297955//1221611509)
    @test q-3p == point(c, 240, 3718)
    @test -20p == point(c,
        872171688955240345797378940145384578112856996417727644408306502486841054959621893457430066791656001//520783120481946829397143140761792686044102902921369189488390484560995418035368116532220330470490000,
        -27483290931268103431471546265260141280423344817266158619907625209686954671299076160289194864753864983185162878307166869927581148168092234359162702751//11884621345605454720092065232176302286055268099954516777276277410691669963302621761108166472206145876157873100626715793555129780028801183525093000000)
end

function test_wnf_ZZp()
    R = ResidueRing(ZZ, 5)

    c = curve(R(1), R(1))
    p = point(c, R(2), R(1))

    @test 2p == point(c, R(2), R(4))
    @test 3p == point(c)
end

function test_wnf_polyZZp()
    R = ResidueRing(ZZ, 5)
    S, s = PolynomialRing(R, "s")
    T, t = FiniteField(3 + s^2, "t")

    c = curve(T(1), T(1))
    p = point(c, 2 + t, 2t)

    @test  -p == point(c, 2 +  t,     3t)
    @test p+p == point(c, 3 +  t, 2 + 0t)
    @test  4p == point(c, 3 + 2t, 4 + 4t)
    @test  9p == point(c)
end

function test_gwnf_QQ()
    c = curve(0, 0, 0, big(-2//1), big(4//1))
    p = point(c, 3, 5)
    q = point(c, -2, 0)

    @test p-q == point(c, 0, -2)
    @test p+p+p+p+p == point(c, 2312883//1142761, -3507297955//1221611509)
    @test 5p == point(c, 2312883//1142761, -3507297955//1221611509)
    @test q-3p == point(c, 240, 3718)
    @test -20p == point(c,
        872171688955240345797378940145384578112856996417727644408306502486841054959621893457430066791656001//520783120481946829397143140761792686044102902921369189488390484560995418035368116532220330470490000,
        -27483290931268103431471546265260141280423344817266158619907625209686954671299076160289194864753864983185162878307166869927581148168092234359162702751//11884621345605454720092065232176302286055268099954516777276277410691669963302621761108166472206145876157873100626715793555129780028801183525093000000)
end

function test_gwnf_ZZp()
    R = ResidueRing(ZZ, 5)

    c = curve(R(0), R(0), R(0), R(1), R(1))
    p = point(c, R(2), R(1))

    @test 2p == point(c, R(2), R(4))
    @test 3p == point(c)
end

function test_gwnf_polyZZp()
    R = ResidueRing(ZZ, 5)
    S, s = PolynomialRing(R, "s")
    T, t = FiniteField(3 + s^2, "t")

    c = curve(T(0), T(0), T(0), T(1), T(1))
    p = point(c, 2 + t, 2t)

    @test  -p == point(c, 2 +  t,     3t)
    @test p+p == point(c, 3 +  t, 2 + 0t)
    @test  4p == point(c, 3 + 2t, 4 + 4t)
    @test  9p == point(c)
end

function test_all()
    print(rpad("Math.EllipticCurves...", 50, ' '))

    test_wnf_QQ()
    test_wnf_ZZp()
    test_wnf_polyZZp()

    test_gwnf_QQ()
    test_gwnf_ZZp()
    test_gwnf_polyZZp()

    println("PASS")
end

end
