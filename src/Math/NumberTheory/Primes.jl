export
    fastprimes, yfactor

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
    include("Primes-fast.jl")
    include("Primes-native-module.jl")
else
    println("Using native implementation for prime-related functions")
    println("")
    fastprimes() = false
    include("Primes-native-reexport.jl")
end
