@reexport module Math

using Reexport.@reexport

@reexport using Nemo
@reexport using StatsFuns
@reexport using ValidatedNumerics

export
    checked_add, checked_sub,
    setbits,
    @activate_mathematica,
    @activate_matlab

checked_add(a::Number, b::Number) = checked_add(promote(a, b)...)
checked_add{T<:Number}(a::T, b::T) = Base.checked_add(a, b)
checked_add(a::BigInt, b::BigInt) = a + b
checked_add(a::BigFloat, b::BigFloat) = a + b

checked_sub(a::Number, b::Number) = checked_sub(promote(a, b)...)
checked_sub{T<:Number}(a::T, b::T) = Base.checked_sub(a, b)
checked_sub(a::BigInt, b::BigInt) = a - b
checked_sub(a::BigFloat, b::BigFloat) = a - b

setbits(n::Integer, idx) = begin
    m = copy(n)
    for i in idx
        m |= one(n) << i
    end
    m
end

macro activate_mathematica(); Expr(:using, :Mathematica); end
macro activate_matlab(); Expr(:using, :MATLAB); end

include("gmp.jl")
include("Series/series.jl")
include("NumberTheory/numbertheory.jl")
include("Combinatorics/combinatorics.jl")

end
