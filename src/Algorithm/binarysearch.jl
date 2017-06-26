export binarysearch

binarysearch(f, z, α::T, β::T) where {T<:Integer} = begin
    if β - α == 1
        y = f(α)
        y == z && return α, α
        y >  z && throw(DomainError())

        y = f(β)
        y == z && return β, β
        y <  z && throw(DomainError())

        return α, β
    end

    m = (α + β) >>> 1
    y = f(m)

    y > z && return binarysearch(f, z, α, m)
    y < z && return binarysearch(f, z, m, β)
    return m, m
end
