export
    DiophantineSolution,
    DiophantineSolutions,
    DiophantineSolutionsListing,
    DiophantineSolutionsNoneXNoneY,
    DiophantineSolutionsAnyXAnyY,
    DiophantineSolutionsOneXAnyY,
    DiophantineSolutionsAnyXOneY,
    DiophantineSolutionsSomeXSomeYAnyT,
    diophantine_solutions


@auto_hash_equals immutable DiophantineSolution{T<:Integer}
    x::T
    y::T
end


abstract DiophantineSolutions{T<:Integer}

immutable DiophantineSolutionsListing{T<:Integer} <: DiophantineSolutions{T}
    solutions
end

immutable DiophantineSolutionsNoneXNoneY{T<:Integer} <: DiophantineSolutions{T}
end

immutable DiophantineSolutionsAnyXAnyY{T<:Integer} <: DiophantineSolutions{T}
end

immutable DiophantineSolutionsOneXAnyY{T<:Integer} <: DiophantineSolutions{T}
    x::T
end

immutable DiophantineSolutionsAnyXOneY{T<:Integer} <: DiophantineSolutions{T}
    y::T
end

immutable DiophantineSolutionsSomeXSomeYAnyT{T<:Integer} <: DiophantineSolutions{T}
    xfunc::Function
    yfunc::Function
end

#immutable DiophantineSolutionsSomeXSomeYSomeT{T<:Integer} <: DiophantineSolutions{T}
#    xfunc::Function
#    yfunc::Function
#    t::AbstractArray{T,1}
#end


diophantine_solutions{T}(solutions::AbstractArray{DiophantineSolution{T},1}) =
    DiophantineSolutionsListing{T}(solutions)


Base.start(it::DiophantineSolutionsListing) = start(it.solutions)
Base.next(it::DiophantineSolutionsListing, state) = next(it.solutions, state)
Base.done(it::DiophantineSolutionsListing, state) = done(it.solutions, state)
Base.eltype(it::DiophantineSolutionsListing) = eltype(typeof(it))
Base.eltype{T}(::Type{DiophantineSolutionsListing{T}}) = DiophantineSolution{T}

Base.start(::DiophantineSolutionsNoneXNoneY) = Nothing
Base.next(::DiophantineSolutionsNoneXNoneY, _) = Nothing
Base.done(::DiophantineSolutionsNoneXNoneY, _) = true
Base.eltype(it::DiophantineSolutionsNoneXNoneY) = eltype(typeof(it))
Base.eltype{T}(::Type{DiophantineSolutionsNoneXNoneY{T}}) = DiophantineSolution{T}

Base.start{T}(::DiophantineSolutionsOneXAnyY{T}) = zero(T)
Base.next(it::DiophantineSolutionsOneXAnyY, state) = DiophantineSolution(it.x, state), state <= 0 ? abs(state) + 1 : -state
Base.done(::DiophantineSolutionsOneXAnyY, _) = false
Base.eltype(it::DiophantineSolutionsOneXAnyY) = eltype(typeof(it))
Base.eltype{T}(::Type{DiophantineSolutionsOneXAnyY{T}}) = DiophantineSolution{T}

Base.start{T}(::DiophantineSolutionsAnyXOneY{T}) = zero(T)
Base.next(it::DiophantineSolutionsAnyXOneY, state) = DiophantineSolution(state, it.y), state <= 0 ? abs(state) + 1 : -state
Base.done(::DiophantineSolutionsAnyXOneY, _) = false
Base.eltype(it::DiophantineSolutionsAnyXOneY) = eltype(typeof(it))
Base.eltype{T}(::Type{DiophantineSolutionsAnyXOneY{T}}) = DiophantineSolution{T}

Base.start(::DiophantineSolutionsSomeXSomeYAnyT) = 0
Base.next(it::DiophantineSolutionsSomeXSomeYAnyT, state) = DiophantineSolution(it.xfunc(state), it.yfunc(state)), state <= 0 ? abs(state) + 1 : -state
Base.done(::DiophantineSolutionsSomeXSomeYAnyT, _) = false
Base.eltype(it::DiophantineSolutionsSomeXSomeYAnyT) = eltype(typeof(it))
Base.eltype{T}(::Type{DiophantineSolutionsSomeXSomeYAnyT{T}}) = DiophantineSolution{T}

#Base.start(::DiophantineSolutionsSomeXSomeYSomeT) = 1
#Base.next(it::DiophantineSolutionsSomeXSomeYSomeT, state) = (s = t[state]; return DiophantineSolution(it.xfunc(s), it.yfunc(s)), state + 1)
#Base.done(it::DiophantineSolutionsSomeXSomeYSomeT, state) = state > length(it.t)
#Base.eltype(it::DiophantineSolutionsSomeXSomeYSomeT) = eltype(typeof(it))
#Base.eltype{T}(::Type{DiophantineSolutionsSomeXSomeYSomeT{T}}) = DiophantineSolution{T}
