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


abstract AbstractDiophantineSolution{T<:Integer}

@auto_hash_equals immutable DiophantineSolutionXY{T<:Integer} <: AbstractDiophantineSolution{T}
    x::T
    y::T
end


abstract AbstractDiophantineSolutions{T<:AbstractDiophantineSolution}

@auto_hash_equals immutable DiophantineSolutions{T<:AbstractDiophantineSolution} <: AbstractDiophantineSolutions{T}
    solutions::Array{T,1}
end


abstract AbstractDiophantineSolutionsXY{T<:Integer} <: AbstractDiophantineSolutions{DiophantineSolutionXY{T}}

immutable DiophantineSolutionsNoneXNoneY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
end

immutable DiophantineSolutionsAnyXAnyY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
end

@auto_hash_equals immutable DiophantineSolutionsOneXAnyY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
    x::T
end

@auto_hash_equals immutable DiophantineSolutionsAnyXOneY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
    y::T
end

@auto_hash_equals immutable DiophantineSolutionsLinearXLinearY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
    mx::T
    nx::T
    my::T
    ny::T
end

@auto_hash_equals immutable DiophantineSolutionsQuadraticXQuadraticY{T<:Integer} <: AbstractDiophantineSolutionsXY{T}
    ax::T
    bx::T
    cx::T
    ay::T
    by::T
    cy::T
end


typealias SolutionXY              DiophantineSolutionXY
typealias Solutions               DiophantineSolutions
typealias NoneX_NoneY             DiophantineSolutionsNoneXNoneY
typealias AnyX_AnyY               DiophantineSolutionsAnyXAnyY
typealias OneX_AnyY               DiophantineSolutionsOneXAnyY
typealias AnyX_OneY               DiophantineSolutionsAnyXOneY
typealias LinearXLinearY          DiophantineSolutionsLinearXLinearY
typealias QuadraticXQuadraticY    DiophantineSolutionsQuadraticXQuadraticY


diophantine_solution{T<:Integer}(x::T, y::T) = SolutionXY(x, y)

diophantine_solutions{T<:AbstractDiophantineSolution}(s::Array{T,1}) = Solutions{T}(s)
@compat diophantine_solutions{T<:Integer}(s::Tuple{T,T}...) = diophantine_solutions([diophantine_solution(x, y) for (x, y) in s])
@compat diophantine_solutions{T<:Integer}(s::AbstractArray{Tuple{T,T},1}) = diophantine_solutions(s...)

diophantine_nonex_noney(T::Type = Int) = NoneX_NoneY{T}()
diophantine_anyx_anyy(T::Type = Int) = AnyX_AnyY{T}()
diophantine_onex_anyy{T<:Integer}(x::T) = OneX_AnyY{T}(x)
diophantine_anyx_oney{T<:Integer}(y::T) = AnyX_OneY{T}(y)
diophantine_linearx_lineary{T<:Integer}(mx::T, nx::T, my::T, ny::T) = LinearXLinearY{T}(mx, nx, my, ny)
diophantine_quadraticx_quadraticy{T<:Integer}(ax::T, bx::T, cx::T, ay::T, by::T, cy::T) = QuadraticXQuadraticY{T}(ax, bx, cx, ay, by, cy)


Base.show(io::IO, sol::SolutionXY)              = print(io, "x=$(sol.x) ∧ y=$(sol.y)")
Base.show(io::IO, sol::Solutions)               = print(io, sol.solutions)    # writemime(io, MIME("text/plain"), sol.solutions)
Base.show(io::IO, ::NoneX_NoneY)                = print(io, "∅")
Base.show(io::IO, ::AnyX_AnyY)                  = print(io, "∀t,s∈ℤ: x=t ∧ y=s")
Base.show(io::IO, sol::OneX_AnyY)               = print(io, "∀t∈ℤ: x=$(sol.x) ∧ y=t")
Base.show(io::IO, sol::AnyX_OneY)               = print(io, "∀t∈ℤ: x=t ∧ y=$(sol.y)")
Base.show(io::IO, sol::LinearXLinearY)          = print(io, "∀t∈ℤ: x=$(formatlinear(sol.mx, sol.nx)) ∧ y=$(formatlinear(sol.my, sol.ny))")
Base.show(io::IO, sol::QuadraticXQuadraticY)    = print(io, "∀t∈ℤ: x=$(formatquadratic(sol.ax, sol.bx, sol.cx)) ∧ y=$(formatquadratic(sol.ay, sol.by, sol.cy))")

formatlinear{T<:Integer}(m::T, n::T) = begin
    nstr = string(n)
    m == 0 && return nstr
    n > 0 && (nstr = "+" * nstr)

    mstr = abs(m) == 1 ? (signbit(m) ? "-" : "") * "t" : "$(m)t"
    n == 0 && return mstr

    mstr * nstr
end

formatquadratic{T<:Integer}(a::T, b::T, c::T) = begin
    linstr = formatlinear(b, c)
    a == 0 && return linstr
    ((b > 0) || (b == 0 && c > 0)) && (linstr = "+" * linstr)

    astr = abs(a) == 1 ? (signbit(a) ? "-" : "") * "t²" : "$(a)t²"
    b == 0 && c == 0 && return astr

    astr * linstr
end


Base.eltype(it::AbstractDiophantineSolutions) = eltype(typeof(it))
Base.eltype{T}(::Type{Solutions{T}}) = T
Base.eltype{T<:Integer}(::Type{NoneX_NoneY{T}}) = DiophantineSolutionXY{T}
Base.eltype{T<:Integer}(::Type{AnyX_AnyY{T}}) = DiophantineSolutionXY{T}
Base.eltype{T<:Integer}(::Type{OneX_AnyY{T}}) = DiophantineSolutionXY{T}
Base.eltype{T<:Integer}(::Type{AnyX_OneY{T}}) = DiophantineSolutionXY{T}
Base.eltype{T<:Integer}(::Type{LinearXLinearY{T}}) = DiophantineSolutionXY{T}
Base.eltype{T<:Integer}(::Type{QuadraticXQuadraticY{T}}) = DiophantineSolutionXY{T}


Base.start(it::Solutions) = start(it.solutions)
Base.next(it::Solutions, state) = next(it.solutions, state)
Base.done(it::Solutions, state) = done(it.solutions, state)

Base.start(::NoneX_NoneY) = Nothing
Base.next(::NoneX_NoneY, _) = Nothing
Base.done(::NoneX_NoneY, _) = true

Base.start(it::OneX_AnyY) = zero(it.x)
Base.next(it::OneX_AnyY, state) = begin
    s = diophantine_solution(it.x, state)
    s, nextstate(state)
end
Base.done(::OneX_AnyY, _) = false

Base.start(it::AnyX_OneY) = zero(it.y)
Base.next(it::AnyX_OneY, state) = begin
    s = diophantine_solution(state, it.y)
    s, nextstate(state)
end
Base.done(::AnyX_OneY, _) = false

Base.start(it::LinearXLinearY) = zero(it.mx)
Base.next(it::LinearXLinearY, state) = begin
    s = diophantine_solution(it.mx * state + it.nx, it.my * state + it.ny)
    s, nextstate(state)
end
Base.done(::LinearXLinearY, _) = false

Base.start(it::QuadraticXQuadraticY) = zero(it.ax)
Base.next(it::QuadraticXQuadraticY, state) = begin
    s = diophantine_solution(it.ax * state^2 + it.bx * state + it.cx, it.ay * state^2 + it.by * state + it.cy)
    s, nextstate(state)
end
Base.done(::QuadraticXQuadraticY, _) = false

nextstate(state::Integer) = state <= zero(state) ? abs(state) + one(state) : -state
