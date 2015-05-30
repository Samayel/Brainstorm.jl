using Brainstorm.DataStructures

mfactor(n::Integer) = n |> Base.factor

genprimes{T<:Integer}(a::T, b::T) = find((i, x) -> x && (i > a), Base.primesmask(b))
genprimes(b::Integer) = genprimes(1, b)

countprimes{T<:Integer}(a::T, b::T) = count((i, x) -> x && (i > a), Base.primesmask(b))
primepi(n::Integer) = countprimes(1, n)

nextprime(n::Integer) = begin
  p = n + one(n)
  while !isprime(p)
    p += one(n)
  end
  p
end
prevprime(n::Integer) = begin
  (n <= 2) && throw(DomainError())

  p = n - one(n)
  while !isprime(p)
    p -= one(n)
  end
  p
end

nprimes(n::Integer) = Base.primes(ceil(Integer, n*log(n+2) + n*log(log(n+2))))[1:n]
nprimes(n::Integer, start::Integer) = start |> allprimes |> s -> take(s, n) |> collect
nthprime(n::Integer) = nprimes(n)[n]


allprimes(n::Integer = 2) = n |> PrimeIterator
someprimes{T<:Integer}(n1::T, n2::T) = n1 |> allprimes |> s -> takewhile(s, x -> x <= n2)
someprimes(n2::Integer) = someprimes(2, n2)

type PrimeIterator
  n::Integer
end

Base.start(it::PrimeIterator) = nextprime(it.n - one(it.n))
Base.next(it::PrimeIterator, state) = state, nextprime(state)
Base.done(::PrimeIterator, state) = false


function find(testf::Function, A::AbstractArray)
  # use a dynamic-length array to store the indexes, then copy to a non-padded
  # array for the return
  tmpI = Array(Int, 0)
  for i = 1:length(A)
    if testf(i, A[i])
      push!(tmpI, i)
    end
  end
  I = Array(Int, length(tmpI))
  copy!(I, tmpI)
  I
end

function count(testf::Function, A::AbstractArray)
  c = 0
  for i = 1:length(A)
    if testf(i, A[i])
      c += 1
    end
  end
  c
end
