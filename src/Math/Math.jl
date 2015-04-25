module Math

import Base.min
import Base.max

min(n::Number) = n
max(n::Number) = n

iceil(n::Number) = int(ceil(n))
ifloor(n::Number) = int(floor(n))

include("NumberTheory/NumberTheory.jl")

include("Export.jl")

end
