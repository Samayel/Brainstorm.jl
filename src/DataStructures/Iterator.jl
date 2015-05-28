using Iterators

#
# BEGIN
# http://slendermeans.org/julia-iterators.html
#

# Some iterators have been moved into Base
#Base.next(it::Iterators.Repeat{Function}, state) = it.x(), state - 1
#Base.next(it::Iterators.RepeatForever{Function}, state) = it.x(), nothing

immutable TakeWhile{I}
  xs::I
  cond::Function
end

takewhile(xs, cond) = TakeWhile(xs, cond)

Base.start(it::TakeWhile) = begin
  current_state = start(it.xs)
  done(it.xs, current_state) && return true, nothing, nothing

  current_value, next_state = next(it.xs, current_state)
  false, current_value, next_state
end

Base.next(it::TakeWhile, state) = begin
  _, current_value, next_state = state
  done(it.xs, next_state) && return current_value, (true, nothing, nothing)

  next_value, nextnext_state = next(it.xs, next_state)
  current_value, (false, next_value, nextnext_state)
end

Base.done(it::TakeWhile, state) = begin
  current_done, current_value, _ = state
  current_done || !it.cond(current_value)
end

#
# END
# http://slendermeans.org/julia-iterators.html
#
