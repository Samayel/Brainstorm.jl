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

allfibonacci() = allfibonacci(0, 1)
allfibonacci(T::Type) = allfibonacci(zero(T), one(T))
allfibonacci(x1::Integer, x2::Integer) = allfibonacci(promote(x1, x2)...)
allfibonacci{T<:Integer}(x1::T, x2::T) = FibonacciInfiniteIterator{T}(x1, x2)

somefibonacci{T<:Integer}(xmax::T) = somefibonacci(xmax, zero(T), one(T))
somefibonacci(xmax::Integer, x1::Integer, x2::Integer) =
  somefibonacci(promote(xmax, x1, x2)...)
somefibonacci{T<:Integer}(xmax::T, x1::T, x2::T) =
  FibonacciRangeIterator{T}(x1, x2, xmax)

Base.start{T<:FibonacciAbstractIterator}(fib::T) = (fib.x2 - fib.x1, fib.x1)
Base.next{T<:FibonacciAbstractIterator}(fib::T, state) =
  (state[2], (state[2], sum(state)))

Base.done(fib::FibonacciInfiniteIterator, state) = false
Base.done(fib::FibonacciRangeIterator, state) = state[2] > fib.xmax

nfibonacci{T<:Integer}(n::T, S::Type = Int) = take(allfibonacci(S), n)
nthfibonacci{T<:Integer}(n::T, S::Type = Int) = first(drop(allfibonacci(S), n-1))
