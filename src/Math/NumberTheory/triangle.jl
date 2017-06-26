export
    istriangular,
    nthtriangular, ntriangular,
    alltriangular, sometriangular, exacttriangular,
    primitive_pythagorean_triples

istriangular(n::Integer) = isperfectsquare(8*n + 1)

nthtriangular(n::Integer) = (n * (n+1)) ÷ 2
ntriangular(n::Int, T::Type = Int) = collect(exacttriangular(n, T))

alltriangular(T::Type = Int) = TriangularIterator{T}()
sometriangular(xmax::T) where {T<:Integer} = @pipe alltriangular(T) |> takewhile(x -> x <= xmax, _)
exacttriangular(n::Int, T::Type = Int) = @pipe alltriangular(T) |> take(_, n)

struct TriangularIterator{T<:Integer}
end

Base.start(::TriangularIterator{T}) where {T<:Integer} = zero(T), one(T)
Base.next(::TriangularIterator{T}, state) where {T<:Integer} = begin
    s, n = state
    s += n
    s, (s, n + 1)
end
Base.done(::TriangularIterator, _) = false

Base.eltype(it::TriangularIterator) = Base.eltype(typeof(it))
Base.eltype(::Type{TriangularIterator{T}}) where {T<:Integer} = T

Base.iteratorsize(::TriangularIterator) = Base.IsInfinite()



primitive_pythagorean_triples(T::Type = Int) = PrimitivePythagoreanTripleIterator{T}()
primitive_pythagorean_triples(maxperimeter::T) where {T} = PrimitivePythagoreanTriplePerimeterIterator{T}(maxperimeter)


abstract type PrimitivePythagoreanTripleIteratorBase{T<:Integer} end

struct PrimitivePythagoreanTripleIterator{T<:Integer} <: PrimitivePythagoreanTripleIteratorBase{T}
end

struct PrimitivePythagoreanTriplePerimeterIterator{T<:Integer} <: PrimitivePythagoreanTripleIteratorBase{T}
    maximum::T
end


Base.start(::PrimitivePythagoreanTripleIterator{T}) where {T} = begin
    q = List{Array{T,1}}()
    n = push!(q, [3,4,5])
    q, n
end
Base.start(it::PrimitivePythagoreanTriplePerimeterIterator{T}) where {T} = begin
    q = List{Array{T,1}}()
    n = it.maximum >= 12 ? push!(q, [3,4,5]) : q.node
    q, n
end

Base.next(::PrimitivePythagoreanTripleIterator, state) = begin
    q, n = state
    n.data, (q, next!(q, n))
end
Base.next(it::PrimitivePythagoreanTriplePerimeterIterator, state) = begin
    q, n = state
    n.data, (q, next!(q, n, it.maximum))
end

Base.done(::PrimitivePythagoreanTripleIteratorBase, state) = begin
    q, n = state
    iseol(q, n)
end

Base.eltype(it::PrimitivePythagoreanTripleIteratorBase) = Base.eltype(typeof(it))
Base.eltype(::Type{PrimitivePythagoreanTripleIterator{T}}) where {T} = Array{T,1}
Base.eltype(::Type{PrimitivePythagoreanTriplePerimeterIterator{T}}) where {T} = Array{T,1}

Base.iteratorsize(::PrimitivePythagoreanTripleIterator) = Base.IsInfinite()
Base.iteratorsize(::PrimitivePythagoreanTriplePerimeterIterator) = Base.SizeUnknown()


iseol(q::List{T}, n::ListNode{T}) where {T} = n == q.node

next!(q::List{T}, n::ListNode{T}) where {T} = begin
    n = n.next
    iseol(q, n) || return n

    x, y, z = calculate(shift!(q)...)
    n = push!(q, x)
    push!(q, y)
    push!(q, z)
    n
end

next!(q::List{T}, n::ListNode{T}, maxsum) where {T} = begin
    n = n.next
    iseol(q, n) || return n

    while iseol(q, n) && !isempty(q)
        x, y, z = calculate(shift!(q)...)
        sum(x) <= maxsum && (nx = push!(q, x); n = nx)
        sum(y) <= maxsum && (ny = push!(q, y); n = iseol(q, n) ? ny : n)
        sum(z) <= maxsum && (nz = push!(q, z); n = iseol(q, n) ? nz : n)
    end
    n
end

calculate(a, b, c) = begin
    x = [ a - 2b + 2c,  2a - b + 2c,  2a - 2b + 3c] # const U = [ 1  2  2, -2 -1 -2, 2 2 3], [a b c] * U
    y = [ a + 2b + 2c,  2a + b + 2c,  2a + 2b + 3c] # const A = [ 1  2  2,  2  1  2, 2 2 3], [a b c] * A
    z = [-a + 2b + 2c, -2a + b + 2c, -2a + 2b + 3c] # const D = [-1 -2 -2,  2  1  2, 2 2 3], [a b c] * D
    x, y, z
end
