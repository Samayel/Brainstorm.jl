export
    isprime,
    fastprimes,
    maskprimes,
    twinprimes,
    coprime, eulerphi

useprimesieve = false
try
    eval(Expr(:import,:PrimeSieve))
    useprimesieve = true
catch err
    @show err
end

if useprimesieve
    println("Using PrimeSieve package for primes functions")
    println("")
    fastprimes() = true
    @reexport using PrimeSieve
    include("Primes/fast.jl")
    include("Primes/nativemodule.jl")
else
    println("Using native implementation for primes functions")
    println("")
    fastprimes() = false
    include("Primes/nativereexport.jl")
end

Primes.isprime(n::Integer, mask) = n <= length(mask) ? mask[n] : isprime(n)

maskprimes(n::Integer) = Primes.primesmask(n)

##  Find all twin primes
# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
twinprimes(n::T, m::T) where {T<:Integer} = begin
    P = genprimes(n, m)
    inds = find(diff(P) .== 2)
    hcat(P[inds], P[inds+1])
end

##  Coprimality
# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
coprime(n::T, m::T) where {T<:Integer} = begin
    n == 0 && m == 0 && return false
    gcd(n, m) == 1
end

##  Euler's Phi (or: totient) function
# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
eulerphi(n::Integer) = begin
    n > 0 || error("Argument 'n' must be an integer greater 0")

    phi = n
    for p in primefactors(n)    # must be unique
        phi -= phi ÷ p          # φ = φ * (1 - 1/p)
    end
    phi
end
