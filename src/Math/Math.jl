module Math

import Base.min
import Base.max

min(n::Number) = n
max(n::Number) = n

include("NumberTheory/NumberTheory.jl")

include("Export.jl")

end
