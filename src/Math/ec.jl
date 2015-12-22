@reexport module EllipticCurves

# http://jeremykun.com/2014/02/08/introducing-elliptic-curves/
# http://jeremykun.com/2014/02/24/elliptic-curves-as-python-objects/
# http://jeremykun.com/2014/03/19/connecting-elliptic-curves-with-finite-fields-a-reprise/

export curve, point, contains, samecurve, ideal

import Base: +, -, *
import Nemo: divexact, contains

using AutoHashEquals
using Nemo


abstract Curve{F}

# Weierstrass normal form, y² = x³ + ax + b
@auto_hash_equals immutable WNFCurve{F} <: Curve{F}
    a::F
    b::F
end

# generalized Weierstrass normal form, y² + a₁xy + a₃y = x³ + a₂x² + a₄x + a₆
@auto_hash_equals immutable GWNFCurve{F} <: Curve{F}
    a₁::F
    a₂::F
    a₃::F
    a₄::F
    a₆::F
end

curve(a, b) = curve(promote(a, b)...)
curve{F}(a::F, b::F) = begin
    ec = WNFCurve(a, b)
    singular(ec) && error("curve $(ec) is singular")
    ec
end
curve(a₁, a₂, a₃, a₄, a₆) = curve(promote(a₁, a₂, a₃, a₄, a₆)...)
curve{F}(a₁::F, a₂::F, a₃::F, a₄::F, a₆::F) = begin
    ec = GWNFCurve(a₁, a₂, a₃, a₄, a₆)
    singular(ec) && error("curve $(ec) is singular")
    ec
end

singular(ec::Curve) = discriminant(ec) == 0
smooth(ec::Curve) = !singular(ec)

discriminant(ec::WNFCurve) = -16 * (4*ec.a^3 + 27*ec.b^2)
discriminant(ec::GWNFCurve) = begin
    b₂ =   ec.a₁^2 + 4*ec.a₂
    b₄ = 2*ec.a₄   +   ec.a₁*ec.a₃
    b₆ =   ec.a₃^2 + 4*ec.a₆
    b₈ = (ec.a₁^2)*ec.a₆ + 4*ec.a₂*ec.a₆ - ec.a₁*ec.a₃*ec.a₄ + ec.a₂*(ec.a₃^2) - ec.a₄^2
    -(b₂^2)*b₈ - 8*b₄^3 - 27*b₆^2 + 9*b₂*b₄*b₆
end
contains{F}(ec::WNFCurve{F}, x::F, y::F) = y^2 == x^3 + ec.a*x + ec.b
contains{F}(ec::GWNFCurve{F}, x::F, y::F) = y^2 + ec.a₁*x*y + ec.a₃*y == x^3 + ec.a₂*x^2 + ec.a₄*x + ec.a₆

ring{T}(n::Curve{T}) = T
ring{T<:RingElem}(ec::WNFCurve{T}) = parent(ec.a)
ring{T<:RingElem}(ec::GWNFCurve{T}) = parent(ec.a₁)

field{T<:FieldElem}(ec::Curve{T}) = ring(ec)

Base.show(io::IO, ec::WNFCurve) = print(io, "{y² = x³ + [$(ec.a)]x + [$(ec.b)]   x, y ∈ $(ring(ec))}")
Base.show(io::IO, ec::GWNFCurve) = print(io, "{y² + [$(ec.a₁)]xy + [$(ec.a₃)]y == x³ + [$(ec.a₂)]x² + [$(ec.a₄)]x + [$(ec.a₆)]   x, y ∈ $(ring(ec))}")

ideal(ec::Curve) = point(ec)


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

Base.show(io::IO, p::ConcretePoint) = print(io, "($(p.x), $(p.y)) on elliptic curve $(curve(p))")
Base.show(io::IO, p::IdealPoint) = print(io, "𝒪 on elliptic curve $(curve(p))")

curve(p::Point) = p.ec
contains(ec::Curve, p::Point) = (ec == curve(p)) && contains(ec, p.x, p.y)

samecurve{I,J,C,F}(p::Point{I,C,F}, q::Point{J,C,F}) = curve(p) == curve(q)
samecurve(p::Point, q::Point) = false

ideal(::IdealPoint) = true
ideal(::ConcretePoint) = false

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
divexact(x::Number, y::Number) = x / y

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

end
