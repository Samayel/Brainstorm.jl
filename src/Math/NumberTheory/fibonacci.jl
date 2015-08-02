export
    nthfibonacci, nfibonacci,
    allfibonacci, somefibonacci, exactfibonacci

immutable FibonacciIterator{T<:Integer}
    x1::T
    x2::T
end

nthfibonacci(n::Integer, S::Type = Int) = @pipe allfibonacci(S) |> drop(_, n - one(n)) |> first
nfibonacci(n::Integer, S::Type = Int) = exactfibonacci(n, S) |> collect

allfibonacci(T::Type = Int) = allfibonacci(one(T), one(T))
allfibonacci(x1::Integer, x2::Integer) = FibonacciIterator(promote(x1, x2)...)

somefibonacci(xmax::Integer) = somefibonacci(xmax, one(xmax), one(xmax))
somefibonacci(xmax::Integer, x1::Integer, x2::Integer) = somefibonacci(promote(xmax, x1, x2)...)
somefibonacci{T<:Integer}(xmax::T, x1::T, x2::T) = @pipe allfibonacci(x1, x2) |> takewhile(@anon(x -> x <= xmax), _)

exactfibonacci(n::Integer, S::Type = Int) = exactfibonacci(n, one(S), one(S))
exactfibonacci(n::Integer, x1::Integer, x2::Integer) = exactfibonacci(n, promote(x1, x2)...)
exactfibonacci{S<:Integer}(n::Integer, x1::S, x2::S) = @pipe allfibonacci(x1, x2) |> take(_, n)

Base.start(it::FibonacciIterator) = (checked_sub(it.x2, it.x1), it.x1)
Base.next(::FibonacciIterator, state) = (state[2], (state[2], checked_add(state[1], state[2])))
Base.done(::FibonacciIterator, _) = false

Base.eltype(it::FibonacciIterator) = Base.eltype(typeof(it))
Base.eltype{T}(::Type{FibonacciIterator{T}}) = T
