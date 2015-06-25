export
    fastprimes, factorization

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
