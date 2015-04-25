module Math

import Base.min
import Base.max

min{T<:Number}(n::T) = n
max{T<:Number}(n::T) = n

include("NumberTheory/NumberTheory.jl")

include("Export.jl")

end
