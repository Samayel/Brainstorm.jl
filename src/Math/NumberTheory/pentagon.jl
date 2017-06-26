export
    ispentagonal,
    nthpentagonal, npentagonal,
    allpentagonal, somepentagonal, exactpentagonal

ispentagonal(n::Integer) = begin
    t = 24*n + 1
    r = isqrt(t)
    (r^2 == t) && (r % 6 == 5)
end

nthpentagonal(n::Integer) = (n * (3n-1)) ÷ 2
npentagonal(n::Int, T::Type = Int) = collect(exactpentagonal(n, T))

allpentagonal(T::Type = Int) = PentagonalIterator{T}()
somepentagonal(xmax::T) where {T<:Integer} = @pipe allpentagonal(T) |> takewhile(x -> x <= xmax, _)
exactpentagonal(n::Int, T::Type = Int) = @pipe allpentagonal(T) |> take(_, n)

struct PentagonalIterator{T<:Integer}
end

Base.start(::PentagonalIterator{T}) where {T<:Integer} = zero(T), one(T)
Base.next(::PentagonalIterator{T}, state) where {T<:Integer} = begin
    s, n = state
    s += 3*n - 2
    s, (s, n + 1)
end
Base.done(::PentagonalIterator, _) = false

Base.eltype(it::PentagonalIterator) = Base.eltype(typeof(it))
Base.eltype(::Type{PentagonalIterator{T}}) where {T<:Integer} = T

Base.iteratorsize(::PentagonalIterator) = Base.IsInfinite()
