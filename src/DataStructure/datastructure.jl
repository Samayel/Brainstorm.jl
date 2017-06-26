@reexport module _DataStructure

import Base: getindex, push!, pop!
import Nemo: cols, rows

export
    flatten

# https://groups.google.com/d/msg/julia-users/1QrIhbRA8hs/9PcNeO2N9wQJ
flatten(a::Array{T,1}) where {T} = any(x -> Base.isa(x, Array), a) ? flatten(vcat(map(flatten, a)...)) : a
flatten(a::Array{T}) where {T} = reshape(a, prod(size(a)))
flatten(a) = a

include("iterator.jl")
include("vector.jl")
include("matrix.jl")
include("intset.jl")
include("stack.jl")

end
