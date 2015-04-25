using DataStructures

try
  import PrimeSieve
  println("Using PrimeSieve package for factor(), nprimes() and nthprime()")
catch
  println("Using native functions for factor(), nprimes() and nthprime()")
end

if isdefined(:PrimeSieve)
  factor(n::Integer) = PrimeSieve.mfactor(n)
  nprimes(n::Integer) = PrimeSieve.nprimes(n, 1)
  nthprime(n::Integer) = PrimeSieve.nthprime(n)
else
  nprimes(n::Integer) = primes(iceil(n*log(n+2) + n*log(log(n+2))))[1:n]
  nthprime(n::Integer) = nprimes(n)[n]
end

divisorsigma(n::Integer) = prod([e+1 for e in values(factor(n))])
factorsort(n::Integer) = SortedDict(factor(n))
invfactor(e::Array{Integer,1}) = prod([big(nthprime(i))^e[i] for i = 1:length(e)])

# http://www.primepuzzles.net/problems/prob_019.htm
least_number_with_d_divisors(d::Integer) = min(
  [invfactor(e) for e in least_number_with_d_divisors_exponents(d)]...)

function least_number_with_d_divisors_exponents(d::Integer, i::Integer = 1, prevn::Integer = 0)
  (d <= 1) && return Any[Integer[]]

  f = factorsort(d)
  pmax = last(f)[1]
  k = sum(values(f))

  p = nthprime(k+i-1)
  pi = nthprime(i)
  m = ifloor(log(p) / log(pi))

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
