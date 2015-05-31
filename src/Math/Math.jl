module Math

checked_add(a::Number, b::Number) = checked_add(promote(a, b)...)
checked_add{T<:Number}(a::T, b::T) = Base.checked_add(a, b)
checked_add(a::BigInt, b::BigInt) = a + b
checked_add(a::BigFloat, b::BigFloat) = a + b

checked_sub(a::Number, b::Number) = checked_sub(promote(a, b)...)
checked_sub{T<:Number}(a::T, b::T) = Base.checked_sub(a, b)
checked_sub(a::BigInt, b::BigInt) = a - b
checked_sub(a::BigFloat, b::BigFloat) = a - b

include("Intervals.jl")

include("NumberTheory/NumberTheory.jl")

include("Export.jl")

end
