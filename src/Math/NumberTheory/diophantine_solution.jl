export
    AbstractDiophantineSolution,
    AbstractDiophantineSolutions,
    AbstractDiophantineSolutionsXY,
    DiophantineSolutionXY,
    DiophantineSolutions,
    DiophantineSolutionsNoneXNoneY,
    DiophantineSolutionsAnyXAnyY,
    DiophantineSolutionsOneXAnyY,
    DiophantineSolutionsAnyXOneY,
    DiophantineSolutionsLinearXLinearY,
    DiophantineSolutionsQuadraticXQuadraticY,
    diophantine_solution,
    diophantine_solutions,
    diophantine_nonex_noney,
    diophantine_anyx_anyy,
    diophantine_onex_anyy,
    diophantine_anyx_oney,
    diophantine_linearx_lineary,
    diophantine_quadraticx_quadraticy


abstract type AbstractDiophantineSolution{T<:Integer} end

@auto_hash_equals struct DiophantineSolutionXY{T<:Integer} <: AbstractDiophantineSolution{T}
    x::T
    y::T
end


abstract type AbstractDiophantineSolutions{T<:AbstractDiophantineSolution} end

@auto_hash_equals struct DiophantineSolutions{T<:AbstractDiophantineSolution} <: AbstractDiophantineSolutions{T}
    solutions::Array{T,1}
end


abstract type AbstractDiophantineSolutionsXY{T<:Integer} <: AbstractDiophantineSolutions{DiophantineSolutionXY{T}} end

struct DiophantineSolutionsNoneXNoneY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
end

struct DiophantineSolutionsAnyXAnyY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
end

@auto_hash_equals struct DiophantineSolutionsOneXAnyY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
    x::T
end

@auto_hash_equals struct DiophantineSolutionsAnyXOneY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
    y::T
end

@auto_hash_equals struct DiophantineSolutionsLinearXLinearY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
    mx::T
    nx::T
    my::T
    ny::T
end

@auto_hash_equals struct DiophantineSolutionsQuadraticXQuadraticY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
    ax::T
    bx::T
    cx::T
    ay::T
    by::T
    cy::T
end


const SolutionXY            = DiophantineSolutionXY
const Solutions             = DiophantineSolutions
const NoneX_NoneY           = DiophantineSolutionsNoneXNoneY
const AnyX_AnyY             = DiophantineSolutionsAnyXAnyY
const OneX_AnyY             = DiophantineSolutionsOneXAnyY
const AnyX_OneY             = DiophantineSolutionsAnyXOneY
const LinearXLinearY        = DiophantineSolutionsLinearXLinearY
const QuadraticXQuadraticY  = DiophantineSolutionsQuadraticXQuadraticY


diophantine_solution(x::T, y::T) where {T<:Integer} = SolutionXY(x, y)

diophantine_solutions(s::Array{T,1}) where {T<:AbstractDiophantineSolution} = Solutions{T}(s)
diophantine_solutions(s::Tuple{T,T}...) where {T<:Integer} = diophantine_solutions([diophantine_solution(x, y) for (x, y) in s])
diophantine_solutions(s::AbstractArray{Tuple{T,T},1}) where {T<:Integer} = diophantine_solutions(s...)

diophantine_nonex_noney(T::Type = Int) = NoneX_NoneY{T}()
diophantine_anyx_anyy(T::Type = Int) = AnyX_AnyY{T}()
diophantine_onex_anyy(x::T) where {T<:Integer} = OneX_AnyY{T}(x)
diophantine_anyx_oney(y::T) where {T<:Integer} = AnyX_OneY{T}(y)
diophantine_linearx_lineary(mx::T, nx::T, my::T, ny::T) where {T<:Integer} = LinearXLinearY{T}(mx, nx, my, ny)
diophantine_quadraticx_quadraticy(ax::T, bx::T, cx::T, ay::T, by::T, cy::T) where {T<:Integer} = QuadraticXQuadraticY{T}(ax, bx, cx, ay, by, cy)


Base.show(io::IO, sol::SolutionXY)              = print(io, "x=$(sol.x) ∧ y=$(sol.y)")
Base.show(io::IO, sol::Solutions)               = print(io, sol.solutions)    # writemime(io, MIME("text/plain"), sol.solutions)
Base.show(io::IO, ::NoneX_NoneY)                = print(io, "∅")
Base.show(io::IO, ::AnyX_AnyY)                  = print(io, "∀t,s∈ℤ: x=t ∧ y=s")
Base.show(io::IO, sol::OneX_AnyY)               = print(io, "∀t∈ℤ: x=$(sol.x) ∧ y=t")
Base.show(io::IO, sol::AnyX_OneY)               = print(io, "∀t∈ℤ: x=t ∧ y=$(sol.y)")
Base.show(io::IO, sol::LinearXLinearY)          = print(io, "∀t∈ℤ: x=$(formatlinear(sol.mx, sol.nx)) ∧ y=$(formatlinear(sol.my, sol.ny))")
Base.show(io::IO, sol::QuadraticXQuadraticY)    = print(io, "∀t∈ℤ: x=$(formatquadratic(sol.ax, sol.bx, sol.cx)) ∧ y=$(formatquadratic(sol.ay, sol.by, sol.cy))")

formatlinear(m::T, n::T) where {T<:Integer} = begin
    nstr = string(n)
    m == 0 && return nstr
    n > 0 && (nstr = "+" * nstr)

    mstr = abs(m) == 1 ? (signbit(m) ? "-" : "") * "t" : "$(m)t"
    n == 0 && return mstr

    mstr * nstr
end

formatquadratic(a::T, b::T, c::T) where {T<:Integer} = begin
    linstr = formatlinear(b, c)
    a == 0 && return linstr
    ((b > 0) || (b == 0 && c > 0)) && (linstr = "+" * linstr)

    astr = abs(a) == 1 ? (signbit(a) ? "-" : "") * "t²" : "$(a)t²"
    b == 0 && c == 0 && return astr

    astr * linstr
end


Base.eltype(it::AbstractDiophantineSolutions) = eltype(typeof(it))
Base.eltype(::Type{Solutions{T}}) where {T} = T
Base.eltype(::Type{NoneX_NoneY{T}}) where {T<:Integer} = DiophantineSolutionXY{T}
Base.eltype(::Type{AnyX_AnyY{T}}) where {T<:Integer} = DiophantineSolutionXY{T}
Base.eltype(::Type{OneX_AnyY{T}}) where {T<:Integer} = DiophantineSolutionXY{T}
Base.eltype(::Type{AnyX_OneY{T}}) where {T<:Integer} = DiophantineSolutionXY{T}
Base.eltype(::Type{LinearXLinearY{T}}) where {T<:Integer} = DiophantineSolutionXY{T}
Base.eltype(::Type{QuadraticXQuadraticY{T}}) where {T<:Integer} = DiophantineSolutionXY{T}


Base.start(it::Solutions) = start(it.solutions)
Base.next(it::Solutions, state) = next(it.solutions, state)
Base.done(it::Solutions, state) = done(it.solutions, state)
Base.length(it::Solutions) = length(it.solutions)

Base.start(::NoneX_NoneY) = Void
Base.next(::NoneX_NoneY, _) = Void
Base.done(::NoneX_NoneY, _) = true
Base.length(::NoneX_NoneY) = 0

Base.start(it::OneX_AnyY) = zero(it.x)
Base.next(it::OneX_AnyY, state) = begin
    s = diophantine_solution(it.x, state)
    s, nextstate(state)
end
Base.done(::OneX_AnyY, _) = false
Base.iteratorsize(::OneX_AnyY) = Base.IsInfinite()

Base.start(it::AnyX_OneY) = zero(it.y)
Base.next(it::AnyX_OneY, state) = begin
    s = diophantine_solution(state, it.y)
    s, nextstate(state)
end
Base.done(::AnyX_OneY, _) = false
Base.iteratorsize(::AnyX_OneY) = Base.IsInfinite()

Base.start(it::LinearXLinearY) = zero(it.mx)
Base.next(it::LinearXLinearY, state) = begin
    s = diophantine_solution(it.mx * state + it.nx, it.my * state + it.ny)
    s, nextstate(state)
end
Base.done(::LinearXLinearY, _) = false
Base.iteratorsize(::LinearXLinearY) = Base.IsInfinite()

Base.start(it::QuadraticXQuadraticY) = zero(it.ax)
Base.next(it::QuadraticXQuadraticY, state) = begin
    s = diophantine_solution(it.ax * state^2 + it.bx * state + it.cx, it.ay * state^2 + it.by * state + it.cy)
    s, nextstate(state)
end
Base.done(::QuadraticXQuadraticY, _) = false
Base.iteratorsize(::QuadraticXQuadraticY) = Base.IsInfinite()

nextstate(state::Integer) = state <= zero(state) ? abs(state) + one(state) : -state
