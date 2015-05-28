using Brainstorm.DataStructures
using Iterators: take, drop

immutable FibonacciIterator{T<:Integer}
  x1::T
  x2::T
end

nthfibonacci{T<:Integer}(n::T, S::Type = Int) =
  allfibonacci(S) |>
  s -> drop(s, n - one(T)) |>
  first
nfibonacci{T<:Integer}(n::T, S::Type = Int) = collect(exactfibonacci(n, S))

allfibonacci(T::Type = Int) = allfibonacci(one(T), one(T))
allfibonacci(x1::Integer, x2::Integer) = allfibonacci(promote(x1, x2)...)
allfibonacci{T<:Integer}(x1::T, x2::T) = FibonacciIterator{T}(x1, x2)

somefibonacci{T<:Integer}(xmax::T) = somefibonacci(xmax, one(T), one(T))
somefibonacci(xmax::Integer, x1::Integer, x2::Integer) = somefibonacci(promote(xmax, x1, x2)...)
somefibonacci{T<:Integer}(xmax::T, x1::T, x2::T) =
  allfibonacci(x1, x2) |>
  s -> takewhile(s, x -> x <= xmax)

exactfibonacci(n::Int, S::Type = Int) = exactfibonacci(n, one(S), one(S))
exactfibonacci(n::Int, x1::Integer, x2::Integer) = exactfibonacci(n, promote(x1, x2)...)
exactfibonacci{S<:Integer}(n::Int, x1::S, x2::S) =
  allfibonacci(x1, x2) |>
  s -> take(s, n)

Base.start(it::FibonacciIterator) = (checked_sub(it.x2, it.x1), it.x1)
Base.next(it::FibonacciIterator, state) = (state[2], (state[2], checked_add(state[1], state[2])))
Base.done(it::FibonacciIterator, state) = false
Base.eltype(it::FibonacciIterator) = typeof(it.x1)
