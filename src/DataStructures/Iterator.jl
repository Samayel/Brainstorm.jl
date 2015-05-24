using Iterators

#
# BEGIN
# http://slendermeans.org/julia-iterators.html
#

Base.next(it::Iterators.Repeat{Function}, state) = it.x(), state - 1
Base.next(it::Iterators.RepeatForever{Function}, state) = it.x(), nothing

immutable TakeWhile{I}
  xs::I
  cond::Function
end

immutable TakeUntil{I}
  xs::I
  cond::Function
end

takewhile(xs, cond) = TakeWhile(xs, cond)
takeuntil(xs, cond) = TakeUntil(xs, cond)

Base.start(it::TakeWhile) = start(it.xs)
Base.start(it::TakeUntil) = start(it.xs), false

Base.next(it::TakeWhile, state) = next(it.xs, state)
Base.next(it::TakeUntil, state) = begin
  i, s = next(it.xs, state[1])
  i, (s, it.cond(i))
end

Base.done(it::TakeWhile, state) = begin
  i, _ = next(it, state)
  !it.cond(i) || done(it.xs, state)
end
Base.done(it::TakeUntil, state) = begin
  s, iscond = state
  iscond || done(it.xs, s)
end

#
# END
# http://slendermeans.org/julia-iterators.html
#
