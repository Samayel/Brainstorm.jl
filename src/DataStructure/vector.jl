export
    rotations

rotations{T}(v::AbstractArray{T,1}) = VectorRotationsIterator(v)

immutable VectorRotationsIterator{T}
    v::T
end

Base.start(::VectorRotationsIterator) = 0
Base.next(it::VectorRotationsIterator, state) = circshift(it.v, state), state - 1
Base.done(it::VectorRotationsIterator, state) = abs(state) >= length(it.v)

Base.eltype(it::VectorRotationsIterator) = Base.eltype(typeof(it))
Base.eltype{T}(::Type{VectorRotationsIterator{T}}) = T

Base.length(it::VectorRotationsIterator) = length(it.v)
