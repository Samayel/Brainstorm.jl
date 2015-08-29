export
    AbstractDiophantineSolution,
    AbstractDiophantineSolutions,
    DiophantineSolutionXY,
    DiophantineSolutions,
    DiophantineSolutionsNoneXNoneY,
    DiophantineSolutionsAnyXAnyY,
    DiophantineSolutionsOneXAnyY,
    DiophantineSolutionsAnyXOneY,
    DiophantineSolutionsLinearXLinearY,
    diophantine_solution,
    diophantine_solutions,
    diophantine_nonex_noney,
    diophantine_anyx_anyy,
    diophantine_onex_anyy,
    diophantine_anyx_oney,
    diophantine_linearx_lineary


abstract AbstractDiophantineSolution{T<:Integer}
abstract AbstractDiophantineSolutions{T<:AbstractDiophantineSolution}


@auto_hash_equals immutable DiophantineSolutionXY{T<:Integer} <: AbstractDiophantineSolution{T}
    x::T
    y::T
end


@auto_hash_equals immutable DiophantineSolutions{T<:AbstractDiophantineSolution} <: AbstractDiophantineSolutions{T}
    solutions::Array{T,1}
end

immutable DiophantineSolutionsNoneXNoneY{T<:DiophantineSolutionXY} <: AbstractDiophantineSolutions{T}
end

immutable DiophantineSolutionsAnyXAnyY{T<:DiophantineSolutionXY} <: AbstractDiophantineSolutions{T}
end

@auto_hash_equals immutable DiophantineSolutionsOneXAnyY{T<:DiophantineSolutionXY, S<:Integer} <: AbstractDiophantineSolutions{T}
    x::S
end

@auto_hash_equals immutable DiophantineSolutionsAnyXOneY{T<:DiophantineSolutionXY, S<:Integer} <: AbstractDiophantineSolutions{T}
    y::S
end

@auto_hash_equals immutable DiophantineSolutionsLinearXLinearY{T<:DiophantineSolutionXY, S<:Integer} <: AbstractDiophantineSolutions{T}
    mx::S
    nx::S
    my::S
    ny::S
end

typealias SolutionXY        DiophantineSolutionXY
typealias Solutions         DiophantineSolutions
typealias NoneX_NoneY       DiophantineSolutionsNoneXNoneY
typealias AnyX_AnyY         DiophantineSolutionsAnyXAnyY
typealias OneX_AnyY         DiophantineSolutionsOneXAnyY
typealias AnyX_OneY         DiophantineSolutionsAnyXOneY
typealias LinearXLinearY    DiophantineSolutionsLinearXLinearY


diophantine_solution{T<:Integer}(x::T, y::T) = SolutionXY(x, y)

diophantine_solutions{T<:AbstractDiophantineSolution}(s::Array{T,1}) = Solutions{T}(s)
@compat diophantine_solutions{T<:Integer}(s::Tuple{T,T}...) = diophantine_solutions([diophantine_solution(x, y) for (x, y) in s])
@compat diophantine_solutions{T<:Integer}(s::AbstractArray{Tuple{T,T},1}) = diophantine_solutions(s...)

diophantine_nonex_noney(T::Type = Int) = NoneX_NoneY{SolutionXY{T}}()
diophantine_anyx_anyy(T::Type = Int) = AnyX_AnyY{SolutionXY{T}}()
diophantine_onex_anyy{T<:Integer}(x::T) = OneX_AnyY{SolutionXY{T},T}(x)
diophantine_anyx_oney{T<:Integer}(y::T) = AnyX_OneY{SolutionXY{T},T}(y)
diophantine_linearx_lineary{T<:Integer}(mx::T, nx::T, my::T, ny::T) = LinearXLinearY{SolutionXY{T},T}(mx, nx, my, ny)


Base.show(io::IO, sol::SolutionXY)        = print(io, "x=$(sol.x) ∧ y=$(sol.y)")
Base.show(io::IO, ::NoneX_NoneY)          = print(io, "∅")
Base.show(io::IO, ::AnyX_AnyY)            = print(io, "∀t,s∈ℤ: x=t ∧ y=s")
Base.show(io::IO, sol::OneX_AnyY)         = print(io, "∀t∈ℤ: x=$(sol.x) ∧ y=t")
Base.show(io::IO, sol::AnyX_OneY)         = print(io, "∀t∈ℤ: x=t ∧ y=$(sol.y)")
Base.show(io::IO, sol::LinearXLinearY)    = print(io, "∀t∈ℤ: x=$(formatlinear(sol.mx, sol.nx)) ∧ y=$(formatlinear(sol.my, sol.ny))")
Base.show(io::IO, sol::Solutions)         = print(io, sol.solutions)
#Base.show(io::IO, sol::Solutions)        = writemime(io, MIME("text/plain"), sol.solutions)

formatlinear{T<:Integer}(m::T, n::T) = begin
    m == 0 && n == 0 && return "0"

    nstr = string(n)
    m == 0 && return nstr

    mstr = abs(m) == 1 ? (signbit(m) ? "-" : "") * "t" : "$(m)t"
    n == 0 && return mstr

    mstr * nstr
end


Base.eltype(it::AbstractDiophantineSolution) = eltype(typeof(it))
Base.eltype{T}(::Type{SolutionXY{T}}) = T

Base.eltype(it::AbstractDiophantineSolutions) = eltype(typeof(it))
Base.eltype{T}(::Type{Solutions{T}}) = T
Base.eltype{T}(::Type{NoneX_NoneY{T}}) = T
Base.eltype{T}(::Type{AnyX_AnyY{T}}) = T
Base.eltype{T,S}(::Type{OneX_AnyY{T,S}}) = T
Base.eltype{T,S}(::Type{AnyX_OneY{T,S}}) = T
Base.eltype{T,S}(::Type{LinearXLinearY{T,S}}) = T


Base.start(it::Solutions) = start(it.solutions)
Base.next(it::Solutions, state) = next(it.solutions, state)
Base.done(it::Solutions, state) = done(it.solutions, state)

Base.start(::NoneX_NoneY) = Nothing
Base.next(::NoneX_NoneY, _) = Nothing
Base.done(::NoneX_NoneY, _) = true

Base.start(it::OneX_AnyY) = zero(it.x)
Base.next(it::OneX_AnyY, state) = begin
    s = SolutionXY(it.x, state)
    s, nextstate(state)
end
Base.done(::OneX_AnyY, _) = false

Base.start(it::AnyX_OneY) = zero(it.y)
Base.next(it::AnyX_OneY, state) = begin
    s = SolutionXY(state, it.y)
    s, nextstate(state)
end
Base.done(::AnyX_OneY, _) = false

Base.start(it::LinearXLinearY) = zero(it.mx)
Base.next(it::LinearXLinearY, state) = begin
    s = SolutionXY(it.mx * state + it.nx, it.my * state + it.ny)
    s, nextstate(state)
end
Base.done(::LinearXLinearY, _) = false

nextstate(state::Integer) = state <= zero(state) ? abs(state) + one(state) : -state
