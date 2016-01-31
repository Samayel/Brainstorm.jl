@auto_hash_equals immutable Point{I,C,F}
    ec::C   # the curve containing this point
    x::F
    y::F
end

typealias ConcretePoint{C,F} Point{false,C,F}
typealias IdealPoint{C,F}    Point{true, C,F}

point{F}(ec::Curve{F}, x, y) = point(ec, convert(F, x), convert(F, y))
point{F}(ec::Curve{F}, x::F, y::F, valid = false) = begin
    valid || contains(ec, x, y) || error("($(x), $(y)) is not a valid point on $(ec)")
    ConcretePoint{typeof(ec),F}(ec, x, y)
end

point{F}(ec::Curve{F}) = (z = zero(ring(ec)); IdealPoint{typeof(ec),F}(ec, z, z))
ideal(ec::Curve) = point(ec)

# http://sagenb.org/src/schemes/elliptic_curves/ell_generic.py: is_x_coord(self, x)
# http://sagenb.org/src/schemes/elliptic_curves/ell_generic.py: lift_x(self, x, all=False)
point{T}(ec::WNFCurve{T}, x::T) = begin
    y = x
    try
        r = sqrt(x^3 + ec.a * x + ec.b)
        y = convert(T, r)
    catch
    end

    !contains(ec, x, y) && error("no point with x-coordinate $(x) on $(ec)")
    point(ec, x, y, true)
end

rand{T<:FiniteFieldElem}(ec::Curve{T}) = begin
    R = field(ec)
    q = order(R)

    # the following allows the ideal point to be picked
    rand() <= 1 / convert(BigInt, q + 1) && return ideal(ec)

    for _ in 1:100
        x = rand(R)
        try
            p = point(ec, x)
            return p
        catch e
            !isa(e, ErrorException) && rethrow()
        end
    end

    error("no random point on $(ec) could be found")
end

show(io::IO, p::ConcretePoint) = print(io, "($(p.x), $(p.y)) on elliptic curve $(curve(p))")
show(io::IO, p::IdealPoint) = print(io, "𝒪 on elliptic curve $(curve(p))")

curve(p::Point) = p.ec
in(p::Point, ec::Curve) = (ec == curve(p)) && contains(ec, p.x, p.y)

samecurve{I,J,C,F}(p::Point{I,C,F}, q::Point{J,C,F}) = curve(p) == curve(q)
samecurve(p::Point, q::Point) = false

isideal(::IdealPoint) = true
isideal(::ConcretePoint) = false

-(p::IdealPoint) = p
-{C<:WNFCurve}(p::ConcretePoint{C}) = point(curve(p), p.x, -p.y, true)
-{C<:GWNFCurve}(p::ConcretePoint{C}) = point(curve(p), p.x, -p.y - curve(p).a₁ * p.x - curve(p).a₃, true)
-(p::Point, q::Point) = p + (-q)

+(p::Point, q::IdealPoint) = (samecurve(p, q) || error("$(p) and $(q) have different curves"); p)
+(p::IdealPoint, q::ConcretePoint) = (samecurve(p, q) || error("$(p) and $(q) have different curves"); q)
+{C<:WNFCurve}(p::ConcretePoint{C}, q::ConcretePoint{C}) = begin
    samecurve(p, q) || error("$(p) and $(q) have different curves")

    ec = curve(p)
    if p == q
        p.y == 0 && return ideal(ec)        # vertical line
        m = divexact(3*p.x^2 + ec.a, 2*p.y) # slope of the tangent line
    else
        p.x == q.x && return ideal(ec)      # vertical line
        m = divexact(q.y - p.y, q.x - p.x)  # slope of the secant line
    end

    x = m^2 - q.x - p.x                     # using Vieta's formula for the sum of the roots
    y = m * (x - p.x) + p.y
    point(ec, x, -y, true)                  # do the reflection to get the sum of the two points
end
+{C<:GWNFCurve}(p::ConcretePoint{C}, q::ConcretePoint{C}) = begin
    samecurve(p, q) || error("$(p) and $(q) have different curves")

    ec = curve(p)
    if p.x == q.x
        p.y + q.y + ec.a₁*p.x + ec.a₃ == 0 && return ideal(ec)

        t = 2*p.y + ec.a₁*p.x + ec.a₃
        c = divexact(3*p.x^2  + 2*ec.a₂*p.x +   ec.a₄ - ec.a₁*p.y, t)
        d = divexact(-(p.x^3) +   ec.a₄*p.x + 2*ec.a₆ - ec.a₃*p.y, t)
     else
        c = divexact(q.y - p.y,         q.x - p.x)
        d = divexact(p.y*q.x - q.y*p.x, q.x - p.x)
    end

    Σx = c^2 + ec.a₁*c - ec.a₂ - p.x - q.x
    Σy = -(c + ec.a₁) * Σx - d - ec.a₃
    point(ec, Σx, Σy, true)
end

*(n::Integer, p::IdealPoint) = p
*(p::IdealPoint, n::Integer) = p
*(n::Integer, p::ConcretePoint) = p * n
*(p::ConcretePoint, n::Integer) = begin
    n == 0 && return ideal(curve(p))
    n < 0 && return -p * -n

    q = p
    r = (n & 1 == 1) ? p : ideal(curve(p))

    i = oftype(n, 2)
    while i <= n
      q = q + q
      if n & i == i
        r = q + r
      end
      i = i << 1
    end

    r
end
