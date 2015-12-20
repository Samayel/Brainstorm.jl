module EllipticCurves

# http://jeremykun.com/2014/02/08/introducing-elliptic-curves/
# http://jeremykun.com/2014/02/24/elliptic-curves-as-python-objects/

export curve, point

import Base: +, -, *

using AutoHashEquals


abstract Curve{F}

# Weierstrass normal form, y^2 = x^3 + ax + b
@auto_hash_equals immutable WNFCurve{F} <: Curve{F}
    a::F
    b::F
end

curve(a, b) = curve(promote(a, b)...)
curve{F}(a::F, b::F) = begin
    ec = WNFCurve(a, b)
    singular(ec) && throw(DomainError())
    ec
end

singular(ec::Curve) = discriminant(ec) == 0
smooth(ec::Curve) = !singular(ec)

discriminant(ec::WNFCurve) = -16 * (4 * ec.a^3 + 27 * ec.b^2)
contains{F}(ec::WNFCurve{F}, x::F, y::F) = y^2 == x^3 + ec.a * x + ec.b

Base.show{F}(io::IO, ec::WNFCurve{F}) = print(io, "y^2 = x^3 + [$(ec.a)]x + [$(ec.b)]   x, y ∈ $(F)")


abstract Point{C<:Curve}

@auto_hash_equals immutable ConcretePoint{C,F} <: Point{C}
    ec::C   # the curve containing this point
    x::F
    y::F
end

@auto_hash_equals immutable IdealPoint{C} <: Point{C}
    ec::C
end

point{F}(ec::Curve{F}, x, y) = point(ec, convert(F, x), convert(F, y))
point{F}(ec::Curve{F}, x::F, y::F) = begin
    contains(ec, x, y) || throw(DomainError())
    ConcretePoint(ec, x, y)
end
point(ec::Curve) = IdealPoint(ec)

Base.show(io::IO, p::ConcretePoint) = print(io, "($(p.x), $(p.y)) on elliptic curve $(curve(p))")
Base.show(io::IO, p::IdealPoint) = print(io, "±∞ on elliptic curve $(curve(p))")

curve(p::Point) = p.ec
contains(ec::Curve, p::Point) = (ec == curve(p)) && contains(ec, p.x, p.y)
samecurve{C}(p::Point{C}, q::Point{C}) = curve(p) == curve(q)

-(p::IdealPoint) = p
-{C<:WNFCurve}(p::ConcretePoint{C}) = ConcretePoint(curve(p), p.x, -p.y)
-(p::Point, q::Point) = p + (-q)

+(p::Point, q::IdealPoint) = (samecurve(p, q) || throw(DomainError()); p)
+(p::IdealPoint, q::ConcretePoint) = (samecurve(p, q) || throw(DomainError()); q)
+{C<:WNFCurve}(p::ConcretePoint{C}, q::ConcretePoint{C}) = begin
    samecurve(p, q) || throw(DomainError())

    ec = curve(p)
    if p == q
        p.y == 0 && return IdealPoint(ec)   # vertical line
        m = (3*p.x^2 + ec.a) / (2*p.y)      # slope of the tangent line
    else
        p.x == q.x && return IdealPoint(ec) # vertical line
        m = (q.y - p.y) / (q.x - p.x)       # slope of the secant line
    end

    x = m^2 - q.x - p.x                     # using Vieta's formula for the sum of the roots
    y = m * (x - p.x) + p.y
    ConcretePoint(ec, x, -y)                # do the reflection to get the sum of the two points
end

*(n::Integer, p::IdealPoint) = p
*(p::IdealPoint, n::Integer) = p
*(n::Integer, p::ConcretePoint) = p * n
*(p::ConcretePoint, n::Integer) = begin
    n == 0 && return IdealPoint(curve(p))
    n < 0 && return -p * -n

    q = p
    r = (n & 1 == 1) ? p : IdealPoint(curve(p))

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

end
