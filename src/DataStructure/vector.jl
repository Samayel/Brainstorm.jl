export
    rotations

rotations(v::AbstractArray{T,1}) where {T} = VectorRotationsIterator(v)

struct VectorRotationsIterator{T}
    v::T
end

Base.start(::VectorRotationsIterator) = 0
Base.next(it::VectorRotationsIterator, state) = circshift(it.v, state), state - 1
Base.done(it::VectorRotationsIterator, state) = abs(state) >= length(it.v)

Base.eltype(it::VectorRotationsIterator) = Base.eltype(typeof(it))
Base.eltype(::Type{VectorRotationsIterator{T}}) where {T} = T

Base.length(it::VectorRotationsIterator) = length(it.v)
