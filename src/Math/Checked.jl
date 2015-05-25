checkedadd(a::Number, b::Number) = checkedadd(promote(a, b)...)
checkedadd{T<:Number}(a::T, b::T) = begin
  sum = a + b

  isnegative = signbit(a)
  (isnegative $ signbit(b)) && return sum

  (isnegative && (sum > min(a, b))) && throw(OverflowError())
  (!isnegative && (sum < max(a, b))) && throw(OverflowError())

  sum
end
