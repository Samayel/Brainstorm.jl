module EllipticCurves

using Base.Test
using Brainstorm

function test_wnf_ZZ()
    @test curve(17, 1) == Brainstorm.Math.EllipticCurves.WNFCurve(17, 1)
    @test_throws ErrorException curve(0, 0)

    c = curve(1, 2)
    p = point(c, 1, 2)
    i = ideal(c)
    @test p == Brainstorm.Math.EllipticCurves.ConcretePoint{typeof(c), Int}(c, 1, 2)
    @test_throws ErrorException point(c, 1, 1)
    @test i == Brainstorm.Math.EllipticCurves.IdealPoint{typeof(c), Int}(c, 0, 0)

    @test -p == Brainstorm.Math.EllipticCurves.ConcretePoint{typeof(c), Int}(c, 1, -2)
    @test -i == i

    @test i + i == i
    @test p + i == p
    @test i + p == p
    @test p + (-p) == i
    @test p - p == i

    @test point(c, 1) == p
end

function test_wnf_QQ()
    c = curve(big(-2//1), big(4//1))
    p = point(c, 3, 5)
    q = point(c, -2, 0)

    @test p-q == point(c, 0, -2)
    @test p+p+p == point(c, -237//121, 845 // 1331)
    @test p+p+p+p+p == point(c, 2312883//1142761, -3507297955//1221611509)
    @test 5p == point(c, 2312883//1142761, -3507297955//1221611509)
    @test q-3p == point(c, 240, 3718)
    @test -20p == point(c,
        872171688955240345797378940145384578112856996417727644408306502486841054959621893457430066791656001//520783120481946829397143140761792686044102902921369189488390484560995418035368116532220330470490000,
        -27483290931268103431471546265260141280423344817266158619907625209686954671299076160289194864753864983185162878307166869927581148168092234359162702751//11884621345605454720092065232176302286055268099954516777276277410691669963302621761108166472206145876157873100626715793555129780028801183525093000000)

    @test point(c, big(3//1)) == p
    @test point(c, big(-2//1)) == q
end

function test_wnf_ZZp()
    R = ResidueRing(ZZ, 5)

    c = curve(R(1), R(1))
    p = point(c, R(2), R(1))

    @test 2p == point(c, R(2), R(4))
    @test 3p == ideal(c)

    @test Brainstorm.Math.EllipticCurves.logpx(p, 2) == (Dict(R(2) => 1), 0, point(c, R(2), R(4)))
    @test Brainstorm.Math.EllipticCurves.logpx(p, 3) == (Dict(R(2) => 1), 3, ideal(c))
    @test Brainstorm.Math.EllipticCurves.logpx(p, 4) == (Dict(R(2) => 1), 3, ideal(c))
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
    @test  9p == ideal(c)

    @test Brainstorm.Math.EllipticCurves.logpx(p, 8)  == (Dict((i*p).x => i for i in 1:4), 0, 8p)
    @test Brainstorm.Math.EllipticCurves.logpx(p, 9)  == (Dict((i*p).x => i for i in 1:4), 9, ideal(c))
    @test Brainstorm.Math.EllipticCurves.logpx(p, 10) == (Dict((i*p).x => i for i in 1:4), 9, ideal(c))
end

function test_wnf_group()
    T, t = FiniteField(37, 1, "t")
    c = curve(T(-1), T(3))
    N = 42
    @test order(c, GroupAlgorithm.BabyStepGiantStep) == N
    @test order(point(c, T(2), T(3)), N) == 7
    @test order(gen(c, N, 3),         N) == 3
    @test order(gen(c, N, 7),         N) == 7

    T, t = FiniteField(97, 1, "t")
    c = curve(T(2), T(3))
    N = 100
    @test order(c, GroupAlgorithm.BabyStepGiantStep) == N
    @test order(gen(c, N, 5), N) == 5

    T, t = FiniteField(29, 1, "t")
    c = curve(T(-1), T(1))
    N = 37
    @test order(c, GroupAlgorithm.BabyStepGiantStep) == N
    @test order(gen(c, N, 37), N) == 37
end

function test_gwnf_ZZ()
    @test curve(0, 0, 0, 17, 1) == Brainstorm.Math.EllipticCurves.GWNFCurve(0, 0, 0, 17, 1)
    @test_throws ErrorException curve(0, 0, 0, 0, 0)

    c = curve(0, 0, 0, 1, 2)
    p = point(c, 1, 2)
    i = ideal(c)
    @test p == Brainstorm.Math.EllipticCurves.ConcretePoint{typeof(c), Int}(c, 1, 2)
    @test_throws ErrorException point(c, 1, 1)
    @test i == Brainstorm.Math.EllipticCurves.IdealPoint{typeof(c), Int}(c, 0, 0)

    @test -p == Brainstorm.Math.EllipticCurves.ConcretePoint{typeof(c), Int}(c, 1, -2)
    @test -i == i

    @test i + i == i
    @test p + i == p
    @test i + p == p
    @test p + (-p) == i
    @test p - p == i

    #@test point(c, 1) == p
end

function test_gwnf_QQ()
    c = curve(0, 0, 0, big(-2//1), big(4//1))
    p = point(c, 3, 5)
    q = point(c, -2, 0)

    @test p-q == point(c, 0, -2)
    @test p+p+p == point(c, -237//121, 845 // 1331)
    @test p+p+p+p+p == point(c, 2312883//1142761, -3507297955//1221611509)
    @test 5p == point(c, 2312883//1142761, -3507297955//1221611509)
    @test q-3p == point(c, 240, 3718)
    @test -20p == point(c,
        872171688955240345797378940145384578112856996417727644408306502486841054959621893457430066791656001//520783120481946829397143140761792686044102902921369189488390484560995418035368116532220330470490000,
        -27483290931268103431471546265260141280423344817266158619907625209686954671299076160289194864753864983185162878307166869927581148168092234359162702751//11884621345605454720092065232176302286055268099954516777276277410691669963302621761108166472206145876157873100626715793555129780028801183525093000000)

    #@test point(c, big(3//1)) == p
    #@test point(c, big(-2//1)) == q
end

function test_gwnf_ZZp()
    R = ResidueRing(ZZ, 5)

    c = curve(R(0), R(0), R(0), R(1), R(1))
    p = point(c, R(2), R(1))

    @test 2p == point(c, R(2), R(4))
    @test 3p == ideal(c)

    @test Brainstorm.Math.EllipticCurves.logpx(p, 2) == (Dict(R(2) => 1), 0, point(c, R(2), R(4)))
    @test Brainstorm.Math.EllipticCurves.logpx(p, 3) == (Dict(R(2) => 1), 3, ideal(c))
    @test Brainstorm.Math.EllipticCurves.logpx(p, 4) == (Dict(R(2) => 1), 3, ideal(c))
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
    @test  9p == ideal(c)

    @test Brainstorm.Math.EllipticCurves.logpx(p, 8)  == (Dict((i*p).x => i for i in 1:4), 0, 8p)
    @test Brainstorm.Math.EllipticCurves.logpx(p, 9)  == (Dict((i*p).x => i for i in 1:4), 9, ideal(c))
    @test Brainstorm.Math.EllipticCurves.logpx(p, 10) == (Dict((i*p).x => i for i in 1:4), 9, ideal(c))
end

#=
function test_gwnf_group()
    T, t = FiniteField(37, 1, "t")
    c = curve(T(0), T(0), T(0), T(-1), T(3))
    N = 42
    @test order(c, GroupAlgorithm.BabyStepGiantStep) == N
    @test order(point(c, T(2), T(3)), N) == 7
    @test order(gen(c, N, 3),         N) == 3
    @test order(gen(c, N, 7),         N) == 7

    T, t = FiniteField(97, 1, "t")
    c = curve(T(0), T(0), T(0), T(2), T(3))
    N = 100
    @test order(c, GroupAlgorithm.BabyStepGiantStep) == N
    @test order(gen(c, N, 5), N) == 5

    T, t = FiniteField(29, 1, "t")
    c = curve(T(0), T(0), T(0), T(-1), T(1))
    N = 37
    @test order(c, GroupAlgorithm.BabyStepGiantStep) == N
    @test order(gen(c, N, 37), N) == 37
end
=#

function test_all()
    print(rpad("Math.EllipticCurves...", 50, ' '))

    test_wnf_ZZ()
    test_wnf_QQ()
    test_wnf_ZZp()
    test_wnf_polyZZp()
    test_wnf_group()

    test_gwnf_ZZ()
    test_gwnf_QQ()
    test_gwnf_ZZp()
    test_gwnf_polyZZp()
    #test_gwnf_group()

    println("PASS")
end

end
