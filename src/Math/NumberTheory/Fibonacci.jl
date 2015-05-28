using Iterators: take, drop

abstract FibonacciAbstractIterator

immutable FibonacciInfiniteIterator{T<:Integer} <: FibonacciAbstractIterator
  x1::T
  x2::T
end

immutable FibonacciRangeIterator{T<:Integer} <: FibonacciAbstractIterator
  x1::T
  x2::T
  xmax::T
end

immutable FibonacciCountIterator{T<:Integer, S<:Integer} <: FibonacciAbstractIterator
  n::T
  x1::S
  x2::S
end

nthfibonacci{T<:Integer}(n::T, S::Type = Int) =
  allfibonacci(S) |>
  s -> drop(s, n - one(T)) |>
  first
nfibonacci{T<:Integer}(n::T, S::Type = Int) = collect(exactfibonacci(n, S))

allfibonacci(T::Type = Int) = allfibonacci(one(T), one(T))
allfibonacci(x1::Integer, x2::Integer) = allfibonacci(promote(x1, x2)...)
allfibonacci{T<:Integer}(x1::T, x2::T) = FibonacciInfiniteIterator{T}(x1, x2)

somefibonacci{T<:Integer}(xmax::T) = somefibonacci(xmax, one(T), one(T))
somefibonacci(xmax::Integer, x1::Integer, x2::Integer) =
  somefibonacci(promote(xmax, x1, x2)...)
somefibonacci{T<:Integer}(xmax::T, x1::T, x2::T) =
  FibonacciRangeIterator{T}(x1, x2, xmax)

exactfibonacci(n::Int, S::Type = Int) = exactfibonacci(n, one(S), one(S))
exactfibonacci(n::Int, x1::Integer, x2::Integer) =
  exactfibonacci(n, promote(x1, x2)...)
exactfibonacci{S<:Integer}(n::Int, x1::S, x2::S) =
  FibonacciCountIterator{Int,S}(n, x1, x2)

Base.start{T<:FibonacciAbstractIterator}(it::T) =
  (checked_sub(it.x2, it.x1), it.x1)
Base.start(it::FibonacciCountIterator) =
  (checked_sub(it.x2, it.x1), it.x1, one(it.n))

Base.next{T<:FibonacciAbstractIterator}(it::T, state) =
  (state[2], (state[2], checked_add(state[1], state[2])))
Base.next(it::FibonacciCountIterator, state) =
  (state[2], (state[2], checked_add(state[1], state[2]), state[3] + one(it.n)))

Base.done(it::FibonacciInfiniteIterator, state) = false
Base.done(it::FibonacciRangeIterator, state) = state[2] > it.xmax
Base.done(it::FibonacciCountIterator, state) = state[3] > it.n

Base.eltype(it::FibonacciInfiniteIterator) = typeof(it.x1)
Base.eltype(it::FibonacciRangeIterator) = typeof(it.x1)
Base.eltype(it::FibonacciCountIterator) = typeof(it.x1)

Base.length(it::FibonacciCountIterator) = it.n
