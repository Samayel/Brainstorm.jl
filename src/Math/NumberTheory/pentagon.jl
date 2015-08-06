export
    ispentagonal,
    nthpentagonal, npentagonal,
    allpentagonal, somepentagonal, exactpentagonal

ispentagonal(n::Integer) = begin
    t = 24*n + 1
    r = isqrt(t)
    (r^2 == t) && (r % 6 == 5)
end

nthpentagonal(n::Integer) = div(n * (3n-1), 2)
npentagonal(n::Integer, T::Type = Int) = exactpentagonal(n, T) |> collect

allpentagonal(T::Type = Int) = PentagonalIterator{T}()
somepentagonal{T<:Integer}(xmax::T) = @pipe allpentagonal(T) |> takewhile(@anon(x -> x <= xmax), _)
exactpentagonal(n::Integer, T::Type = Int) = @pipe allpentagonal(T) |> take(_, n)

immutable PentagonalIterator{T<:Integer}
end

Base.start{T<:Integer}(::PentagonalIterator{T}) = zero(T), one(T)
Base.next{T<:Integer}(::PentagonalIterator{T}, state) = begin
    s, n = state
    s += 3*n - 2
    s, (s, n + 1)
end
Base.done(::PentagonalIterator, _) = false

Base.eltype(it::PentagonalIterator) = Base.eltype(typeof(it))
Base.eltype{T<:Integer}(::Type{PentagonalIterator{T}}) = T
