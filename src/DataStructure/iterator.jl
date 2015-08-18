export
    takewhile, dropwhile,
    tmap,
    NestedIterator, DefaultNestedIterator, nested

#
# BEGIN
# http://slendermeans.org/julia-iterators.html
#

# Some iterators have been moved into Base
#Base.next(it::Iterators.Repeat{Function}, state) = it.x(), state - 1
#Base.next(it::Iterators.RepeatForever{Function}, state) = it.x(), nothing

abstract WhileIterator

immutable TakeWhile{I, F} <: WhileIterator
    xs::I
    cond::F
end

immutable DropWhile{I, F} <: WhileIterator
    xs::I
    cond::F
end

takewhile(cond, xs) = TakeWhile(xs, cond)
dropwhile(cond, xs) = DropWhile(xs, cond)

Base.start(it::TakeWhile) = begin
    current_state = start(it.xs)
    done(it.xs, current_state) && return true, nothing, nothing

    current_value, next_state = next(it.xs, current_state)
    false, current_value, next_state
end
Base.start(it::DropWhile) = begin
    current_state = start(it.xs)
    while !done(it.xs, current_state)
        current_value, next_state = next(it.xs, current_state)
        !it.cond(current_value) && return false, current_value, next_state
        current_state = next_state
    end
    true, nothing, nothing
end

Base.next(it::WhileIterator, state) = begin
    _, current_value, next_state = state
    done(it.xs, next_state) && return current_value, (true, nothing, nothing)

    next_value, nextnext_state = next(it.xs, next_state)
    current_value, (false, next_value, nextnext_state)
end

Base.done(it::TakeWhile, state) = begin
    current_done, current_value, _ = state
    current_done || !it.cond(current_value)
end
Base.done(::DropWhile, state) = state[1]

Base.eltype(it::TakeWhile) = Base.eltype(typeof(it))
Base.eltype(it::DropWhile) = Base.eltype(typeof(it))
Base.eltype{I,F}(::Type{TakeWhile{I,F}}) = Base.eltype(I)
Base.eltype{I,F}(::Type{DropWhile{I,F}}) = Base.eltype(I)

#
# END
# http://slendermeans.org/julia-iterators.html
#



immutable TMap{T}
    mapfunc::Base.Callable
    xs::Vector{Any}
end

tmap(mapfunc, resulttype::Type, it1, its...) =
    TMap{resulttype}(mapfunc, Any[it1, its...])

Base.start(it::TMap) = map(start, it.xs)
Base.next(it::TMap, state) = begin
    next_result = map(next, it.xs, state)
    (
        it.mapfunc(map(x -> x[1], next_result)...),
        map(x -> x[2], next_result)
    )
end
Base.done(it::TMap, state) = any(map(done, it.xs, state))

Base.eltype(it::TMap) = Base.eltype(typeof(it))
Base.eltype{T}(::Type{TMap{T}}) = T

Base.length(it::TMap) = minimum(map(x -> length(x), it.xs))



abstract NestedIterator

immutable DefaultNestedIterator{T} <: NestedIterator
    source::T
    level::Int
end

nested{T}(s::T, l::Int = 1) = DefaultNestedIterator{T}(s, l)

create(::NestedIterator, ::Any) = []
combine(::NestedIterator, outer, inner) = "$outer,$inner"


Base.start(it::NestedIterator) = nextstate(it, (Nothing, Nothing, Nothing))

Base.next(it::NestedIterator, state) = begin
    outerit = it.source
    outerstate, innerit, innerstate = state

    outervalue, _ = next(outerit, outerstate)
    innervalue, _ = next(innerit, innerstate)

    value = combine(it, outervalue, innervalue)
    state = nextstate(it, (outerstate, innerit, innerstate))

    value, state
end

Base.done(it::NestedIterator, state) = begin
    outerstate, _, _ = state
    done(it.source, outerstate)
end

nextstate(it::NestedIterator, state) = begin
    outerit = it.source
    outerstate, innerit, innerstate = state

    if outerstate == Nothing
        outerstate = start(outerit)
    end

    done(outerit, outerstate) && return (outerstate, innerit, innerstate)

    if innerit == Nothing
        innerit, innerstate = createinner(it, outerstate)
    else
        _, innerstate = next(innerit, innerstate)
    end

    while done(innerit, innerstate)
        _, outerstate = next(outerit, outerstate)
        done(outerit, outerstate) && break
        innerit, innerstate = createinner(it, outerstate)
    end

    (outerstate, innerit, innerstate)
end

createinner(it::NestedIterator, outerstate) = begin
    outervalue, _ = next(it.source, outerstate)
    innerit = create(it, outervalue)
    innerstate = start(innerit)

    innerit, innerstate
end
