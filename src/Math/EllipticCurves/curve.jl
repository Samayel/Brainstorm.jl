abstract type Curve{F} end

# (short) Weierstrass normal form, y² = x³ + ax + b
@auto_hash_equals struct WNFCurve{F} <: Curve{F}
    a::F
    b::F
end

# generalized Weierstrass normal form, y² + a₁xy + a₃y = x³ + a₂x² + a₄x + a₆
@auto_hash_equals struct GWNFCurve{F} <: Curve{F}
    a₁::F
    a₂::F
    a₃::F
    a₄::F
    a₆::F
end

curve(a, b) = curve(promote(a, b)...)
curve(a::F, b::F) where {F} = begin
    ec = WNFCurve(a, b)
    issingular(ec) && error("curve $(ec) is singular")
    ec
end

curve(a₁, a₂, a₃, a₄, a₆) = curve(promote(a₁, a₂, a₃, a₄, a₆)...)
curve(a₁::F, a₂::F, a₃::F, a₄::F, a₆::F) where {F} = begin
    ec = GWNFCurve(a₁, a₂, a₃, a₄, a₆)
    issingular(ec) && error("curve $(ec) is singular")
    ec
end

issingular(ec::Curve) = discriminant(ec) == 0
issmooth(ec::Curve) = !singular(ec)

discriminant(ec::WNFCurve) = -16 * (4*ec.a^3 + 27*ec.b^2)
discriminant(ec::GWNFCurve) = begin
    b₂ =   ec.a₁^2 + 4*ec.a₂
    b₄ = 2*ec.a₄   +   ec.a₁*ec.a₃
    b₆ =   ec.a₃^2 + 4*ec.a₆
    b₈ = (ec.a₁^2)*ec.a₆ + 4*ec.a₂*ec.a₆ - ec.a₁*ec.a₃*ec.a₄ + ec.a₂*(ec.a₃^2) - ec.a₄^2
    -(b₂^2)*b₈ - 8*b₄^3 - 27*b₆^2 + 9*b₂*b₄*b₆
end

contains(ec::WNFCurve{F}, x::F, y::F) where {F} = y^2 == x^3 + ec.a*x + ec.b
contains(ec::GWNFCurve{F}, x::F, y::F) where {F} = y^2 + ec.a₁*x*y + ec.a₃*y == x^3 + ec.a₂*x^2 + ec.a₄*x + ec.a₆

ring(n::Curve{T}) where {T} = T
ring(ec::WNFCurve{T}) where {T<:RingElem} = parent(ec.a)
ring(ec::GWNFCurve{T}) where {T<:RingElem} = parent(ec.a₁)

field(ec::Curve{T}) where {T<:FieldElem} = ring(ec)

show(io::IO, ec::WNFCurve) = print(io, "{y² = x³ + [$(ec.a)]x + [$(ec.b)]   x, y ∈ $(ring(ec))}")
show(io::IO, ec::GWNFCurve) = print(io, "{y² + [$(ec.a₁)]xy + [$(ec.a₃)]y == x³ + [$(ec.a₂)]x² + [$(ec.a₄)]x + [$(ec.a₆)]   x, y ∈ $(ring(ec))}")
