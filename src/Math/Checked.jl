function checkedadd{T<:Number}(x1::T, x2::T)
  sum = x1 + x2

  isnegative = signbit(x1)
  (isnegative $ signbit(x2)) && return sum

  (isnegative && (sum > min(x1, x2))) && throw(OverflowError())
  (!isnegative && (sum < max(x1, x2))) && throw(OverflowError())

  sum
end
