export
    ishexagonal,
    nthhexagonal, nhexagonal,
    allhexagonal, somehexagonal, exacthexagonal

ishexagonal(n::Integer) = begin
    t = 8*n + 1
    r = isqrt(t)
    (r^2 == t) && (r % 4 == 3)
end

nthhexagonal(n::Integer) = n * (2*n - 1)
nhexagonal(n::Int, T::Type = Int) = collect(exacthexagonal(n, T))

allhexagonal(T::Type = Int) = HexagonalIterator{T}()
somehexagonal(xmax::T) where {T<:Integer} = @pipe allhexagonal(T) |> takewhile(x -> x <= xmax, _)
exacthexagonal(n::Int, T::Type = Int) = @pipe allhexagonal(T) |> take(_, n)

struct HexagonalIterator{T<:Integer}
end

Base.start(::HexagonalIterator{T}) where {T<:Integer} = zero(T), one(T)
Base.next(::HexagonalIterator{T}, state) where {T<:Integer} = begin
    s, n = state
    s += 4*n - 3
    s, (s, n + 1)
end
Base.done(::HexagonalIterator, _) = false

Base.eltype(it::HexagonalIterator) = Base.eltype(typeof(it))
Base.eltype(::Type{HexagonalIterator{T}}) where {T<:Integer} = T

Base.iteratorsize(::HexagonalIterator) = Base.IsInfinite()
