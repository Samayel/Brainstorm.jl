export
  fastprimes

export
  divisorsigma,
  factorsort, invfactor,
  least_number_with_d_divisors

useprimesieve = false
try
  eval(Expr(:import,:PrimeSieve))
  useprimesieve = true
catch err
  @show err
end

if useprimesieve
  println("Using PrimeSieve package for prime-related functions")
  println("")
  fastprimes() = true
  @reexport using PrimeSieve
else
  println("Using native implementation for prime-related functions")
  println("")
  fastprimes() = false
  include("Primes-native.jl")
end

# https://oeis.org/wiki/Divisor_function
divisorsigma{T<:Integer}(n::T, k = 1) = begin
  ((k < 0) || (n <= 0)) && throw(DomainError())
  (n == 1) && return 1

  f = (k == 0) ?
    x -> x[2] + 1 :
    x -> div(x[1]^((x[2] + 1) * k) - 1, x[1]^k - 1)

  @pipe mfactor(n) |> imap(f, _) |> prod
end

factorsort{T<:Integer}(n::T) = mfactor(n) |> SortedDict
invfactor{T<:Integer}(x::Array{T,1}) = [big(nthprime(i))^e for (i, e) = enumerate(x)] |> prod

# http://www.primepuzzles.net/problems/prob_019.htm
least_number_with_d_divisors{T<:Integer}(d::T) =
  @pipe least_number_with_d_divisors_exponents(d) |>
  imap(invfactor, _) |>
  minimum

function least_number_with_d_divisors_exponents{T<:Integer}(d::T, i::Int = 1, prevn::T = 0)
  (d <= 1) && return Any[Integer[]]

  f = factorsort(d)
  pmax = last(f)[1]
  k = sum(values(f))

  p = nthprime(k+i-1)
  pi = nthprime(i)
  m = floor(Integer, log(p) / log(pi))

  c = [pmax]
  for b = 2:m
    !(b in keys(f)) && continue

    for a = b:m
      (a*b <= pmax) && continue
      (d % (a*b) != 0) && continue
      (first(factorsort(a))[1] < b) && continue
      ((i > 1) && (a*b > prevn)) && continue

      push!(c, a*b)
    end
  end

  ans = Any[]
  for ni in c
    for tailn in least_number_with_d_divisors_exponents(div(d, ni), i+1, ni)
      push!(tailn, ni-1)
      push!(ans, tailn)
    end
  end

  return (i == 1) ? [reverse(x) for x in ans] : ans
end
