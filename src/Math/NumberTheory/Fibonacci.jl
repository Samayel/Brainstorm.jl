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
  first(drop(allfibonacci(S), n - one(T)))
nfibonacci{T<:Integer}(n::T, S::Type = Int) = [x for x in exactfibonacci(n, S)]

allfibonacci(T::Type = Int) = allfibonacci(zero(T), one(T))
allfibonacci(x1::Integer, x2::Integer) = allfibonacci(promote(x1, x2)...)
allfibonacci{T<:Integer}(x1::T, x2::T) = FibonacciInfiniteIterator{T}(x1, x2)

somefibonacci{T<:Integer}(xmax::T) = somefibonacci(xmax, zero(T), one(T))
somefibonacci(xmax::Integer, x1::Integer, x2::Integer) =
  somefibonacci(promote(xmax, x1, x2)...)
somefibonacci{T<:Integer}(xmax::T, x1::T, x2::T) =
  FibonacciRangeIterator{T}(x1, x2, xmax)

exactfibonacci(n::Int, S::Type = Int) = exactfibonacci(n, zero(S), one(S))
exactfibonacci(n::Int, x1::Integer, x2::Integer) =
  exactfibonacci(n, promote(x1, x2)...)
exactfibonacci{S<:Integer}(n::Int, x1::S, x2::S) =
  FibonacciCountIterator{Int,S}(n, x1, x2)

Base.start{T<:FibonacciAbstractIterator}(fib::T) = (fib.x2 - fib.x1, fib.x1)
Base.start(fib::FibonacciCountIterator) = (fib.x2 - fib.x1, fib.x1, one(fib.n))

Base.next{T<:FibonacciAbstractIterator}(fib::T, state) =
  (state[2], (state[2], state[1] + state[2]))
Base.next(fib::FibonacciCountIterator, state) =
  (state[2], (state[2], state[1] + state[2], state[3] + one(fib.n)))

Base.done(fib::FibonacciInfiniteIterator, state) = false
Base.done(fib::FibonacciRangeIterator, state) = state[2] > fib.xmax
Base.done(fib::FibonacciCountIterator, state) = state[3] > fib.n

Base.length(fib::FibonacciCountIterator) = fib.n
