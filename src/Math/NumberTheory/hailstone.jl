export
    nexthailstone, hailstonelength, allhailstone


nexthailstone(n::Integer) = begin
    n <= 0 && throw(DomainError())
    iseven(n) ? n ÷ 2 : 3*n + 1
end

hailstonelengthcalc(x, cache) = 1 + hailstonelength(nexthailstone(x), cache)
hailstonelength(n::T, cache::Array{T,1} = zeros(T, 0)) where {T<:Integer} = begin
    n <= 0 && throw(DomainError())
    n == 1 && return one(T)

    n > length(cache) && return hailstonelengthcalc(n, cache)
    (ans = cache[n]) > 0 && return ans
    cache[n] = hailstonelengthcalc(n, cache)
end


struct HailstoneIterator{T<:Integer}
    n::T
end

allhailstone(n::Integer) = begin
    n <= 0 && throw(DomainError())
    HailstoneIterator(n)
end

Base.start(it::HailstoneIterator) = it.n
Base.next(::HailstoneIterator{T}, state) where {T<:Integer} =
    (state, state == 1 ? zero(T) : nexthailstone(state))
Base.done(::HailstoneIterator, state) = state <= 0

Base.eltype(it::HailstoneIterator) = Base.eltype(typeof(it))
Base.eltype(::Type{HailstoneIterator{T}}) where {T} = T

Base.iteratorsize(::HailstoneIterator) = Base.SizeUnknown()
