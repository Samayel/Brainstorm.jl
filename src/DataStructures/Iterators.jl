export
  takewhile, dropwhile

#
# BEGIN
# http://slendermeans.org/julia-iterators.html
#

# Some iterators have been moved into Base
#Base.next(it::Iterators.Repeat{Function}, state) = it.x(), state - 1
#Base.next(it::Iterators.RepeatForever{Function}, state) = it.x(), nothing

abstract WhileIterator

immutable TakeWhile{I} <: WhileIterator
  xs::I
  cond::Function
end

immutable DropWhile{I} <: WhileIterator
  xs::I
  cond::Function
end

takewhile(xs, cond) = TakeWhile(xs, cond)
dropwhile(xs, cond) = DropWhile(xs, cond)

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

Base.next{T<:WhileIterator}(it::T, state) = begin
  _, current_value, next_state = state
  done(it.xs, next_state) && return current_value, (true, nothing, nothing)

  next_value, nextnext_state = next(it.xs, next_state)
  current_value, (false, next_value, nextnext_state)
end

Base.done(it::TakeWhile, state) = begin
  current_done, current_value, _ = state
  current_done || !it.cond(current_value)
end
Base.done(it::DropWhile, state) = state[1]

#
# END
# http://slendermeans.org/julia-iterators.html
#
