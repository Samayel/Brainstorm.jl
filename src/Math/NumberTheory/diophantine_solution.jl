export
    AbstractDiophantineSolution,
    AbstractDiophantineSolutions,
    DiophantineSolutionXY,
    DiophantineSolutions,
    DiophantineSolutionsNoneXNoneY,
    DiophantineSolutionsAnyXAnyY,
    DiophantineSolutionsOneXAnyY,
    DiophantineSolutionsAnyXOneY,
    DiophantineSolutionsSomeXSomeYAnyT,
    diophantine_solution,
    diophantine_solutions,
    diophantine_nonex_noney,
    diophantine_anyx_anyy,
    diophantine_onex_anyy,
    diophantine_anyx_oney,
    diophantine_somex_somey_anyt


abstract AbstractDiophantineSolution{T<:Integer}
abstract AbstractDiophantineSolutions{T<:AbstractDiophantineSolution}


@auto_hash_equals immutable DiophantineSolutionXY{T<:Integer} <: AbstractDiophantineSolution{T}
    x::T
    y::T
end


immutable DiophantineSolutions{T<:AbstractDiophantineSolution} <: AbstractDiophantineSolutions{T}
    solutions
end

immutable DiophantineSolutionsNoneXNoneY{T<:DiophantineSolutionXY} <: AbstractDiophantineSolutions{T}
end

immutable DiophantineSolutionsAnyXAnyY{T<:DiophantineSolutionXY} <: AbstractDiophantineSolutions{T}
end

immutable DiophantineSolutionsOneXAnyY{T<:DiophantineSolutionXY, S<:Integer} <: AbstractDiophantineSolutions{T}
    x::S
end

immutable DiophantineSolutionsAnyXOneY{T<:DiophantineSolutionXY, S<:Integer} <: AbstractDiophantineSolutions{T}
    y::S
end

immutable DiophantineSolutionsSomeXSomeYAnyT{T<:DiophantineSolutionXY} <: AbstractDiophantineSolutions{T}
    xfunc::Function
    yfunc::Function
end

typealias SolutionXY DiophantineSolutionXY
typealias Solutions DiophantineSolutions
typealias NoneX_NoneY DiophantineSolutionsNoneXNoneY
typealias AnyX_AnyY DiophantineSolutionsAnyXAnyY
typealias OneX_AnyY DiophantineSolutionsOneXAnyY
typealias AnyX_OneY DiophantineSolutionsAnyXOneY
typealias SomeX_SomeY_AnyT DiophantineSolutionsSomeXSomeYAnyT


diophantine_solution{T<:Integer}(x::T, y::T) = SolutionXY(x, y)
diophantine_solutions{T<:AbstractDiophantineSolution}(s::AbstractArray{T,1}) = Solutions{T}(s)
diophantine_nonex_noney(T::Type = Int) = NoneX_NoneY{SolutionXY{T}}()
diophantine_anyx_anyy(T::Type = Int) = AnyX_AnyY{SolutionXY{T}}()
diophantine_onex_anyy{T<:Integer}(x::T) = OneX_AnyY{SolutionXY{T},T}(x)
diophantine_anyx_oney{T<:Integer}(y::T) = AnyX_OneY{SolutionXY{T},T}(y)
diophantine_somex_somey_anyt(xfunc, yfunc, T::Type = Int) = SomeX_SomeY_AnyT{SolutionXY{T}}(xfunc, yfunc)


Base.eltype(it::AbstractDiophantineSolution) = eltype(typeof(it))
Base.eltype{T}(::Type{SolutionXY{T}}) = T

Base.eltype(it::AbstractDiophantineSolutions) = eltype(typeof(it))
Base.eltype{T}(::Type{Solutions{T}}) = T
Base.eltype{T}(::Type{NoneX_NoneY{T}}) = T
Base.eltype{T}(::Type{AnyX_AnyY{T}}) = T
Base.eltype{T,S}(::Type{OneX_AnyY{T,S}}) = T
Base.eltype{T,S}(::Type{AnyX_OneY{T,S}}) = T
Base.eltype{T}(::Type{SomeX_SomeY_AnyT{T}}) = T


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

Base.start(::SomeX_SomeY_AnyT) = 0
Base.next(it::SomeX_SomeY_AnyT, state) = begin
    T = eltype(eltype(it))
    s = SolutionXY{T}(it.xfunc(state), it.yfunc(state))
    s, nextstate(state)
end
Base.done(::SomeX_SomeY_AnyT, _) = false

nextstate(state::Integer) = state <= zero(state) ? abs(state) + one(state) : -state
