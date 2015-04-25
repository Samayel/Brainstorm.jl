using DataStructures

try
  eval(Expr(:import,:PrimeSieve))
catch err
  @show err
end

if isdefined(:PrimeSieve)
  println("Using PrimeSieve package for mfactor(), nprimes() and nthprime()")
  mfactor{T<:Integer}(n::T) = PrimeSieve.mfactor(n)
  nprimes{T<:Integer}(n::T) = PrimeSieve.nprimes(n, 1)
  nthprime{T<:Integer}(n::T) = PrimeSieve.nthprime(n)
else
  println("Using native functions for mfactor(), nprimes() and nthprime()")
  mfactor{T<:Integer}(n::T) = factor(n)
  nprimes{T<:Integer}(n::T) =
    primes(ceil(Integer, n*log(n+2) + n*log(log(n+2))))[1:n]
  nthprime{T<:Integer}(n::T) = nprimes(n)[n]
end

divisorsigma{T<:Integer}(n::T) = [e+1 for e in values(mfactor(n))] |> prod
factorsort{T<:Integer}(n::T) = n |> mfactor |> SortedDict
invfactor{T<:Integer}(e::Array{T,1}) =
  [big(nthprime(i))^e[i] for i = 1:length(e)] |> prod

# http://www.primepuzzles.net/problems/prob_019.htm
least_number_with_d_divisors{T<:Integer}(d::T) =
  [invfactor(e) for e in least_number_with_d_divisors_exponents(d)] |> minimum

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
