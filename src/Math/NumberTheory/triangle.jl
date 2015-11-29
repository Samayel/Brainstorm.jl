export
    istriangular,
    nthtriangular, ntriangular,
    alltriangular, sometriangular, exacttriangular,
    primitive_pythagorean_triples

istriangular(n::Integer) = isperfectsquare(8*n + 1)

nthtriangular(n::Integer) = (n * (n+1)) ÷ 2
ntriangular(n::Int, T::Type = Int) = collect(exacttriangular(n, T))

alltriangular(T::Type = Int) = TriangularIterator{T}()
sometriangular{T<:Integer}(xmax::T) = @pipe alltriangular(T) |> takewhile(Functor.leq(xmax), _)
exacttriangular(n::Int, T::Type = Int) = @pipe alltriangular(T) |> take(_, n)

immutable TriangularIterator{T<:Integer}
end

Base.start{T<:Integer}(::TriangularIterator{T}) = zero(T), one(T)
Base.next{T<:Integer}(::TriangularIterator{T}, state) = begin
    s, n = state
    s += n
    s, (s, n + 1)
end
Base.done(::TriangularIterator, _) = false

Base.eltype(it::TriangularIterator) = Base.eltype(typeof(it))
Base.eltype{T<:Integer}(::Type{TriangularIterator{T}}) = T



primitive_pythagorean_triples(T::Type = Int) = PrimitivePythagoreanTripleIterator{T}()
primitive_pythagorean_triples{T}(maxperimeter::T) = PrimitivePythagoreanTriplePerimeterIterator{T}(maxperimeter)


abstract PrimitivePythagoreanTripleIteratorBase{T<:Integer}

immutable PrimitivePythagoreanTripleIterator{T<:Integer} <: PrimitivePythagoreanTripleIteratorBase{T}
end

immutable PrimitivePythagoreanTriplePerimeterIterator{T<:Integer} <: PrimitivePythagoreanTripleIteratorBase{T}
    maximum::T
end


Base.start{T}(::PrimitivePythagoreanTripleIterator{T}) = begin
    q = List{Array{T,1}}()
    n = push!(q, [3,4,5])
    q, n
end
Base.start{T}(it::PrimitivePythagoreanTriplePerimeterIterator{T}) = begin
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
Base.eltype{T}(::Type{PrimitivePythagoreanTripleIterator{T}}) = Array{T,1}
Base.eltype{T}(::Type{PrimitivePythagoreanTriplePerimeterIterator{T}}) = Array{T,1}


iseol{T}(q::List{T}, n::ListNode{T}) = n == q.node

next!{T}(q::List{T}, n::ListNode{T}) = begin
    n = n.next
    iseol(q, n) || return n

    x, y, z = calculate(shift!(q)...)
    n = push!(q, x)
    push!(q, y)
    push!(q, z)
    n
end

next!{T}(q::List{T}, n::ListNode{T}, maxsum) = begin
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
