export
    sqrtmod,
    multiplicativeorder,
    linearmod,
    primitiveroot

Nemo.sqrtmod(x::Integer, m::T) where T<:Integer = convert(T, sqrtmod(fmpz(x), fmpz(m)))

#=
http://rosettacode.org/wiki/Multiplicative_order

One possible algorithm that is efficient also for large numbers is the
following: By the Chinese Remainder Theorem, it's enough to calculate the
multiplicative order for each prime exponent p^k of m, and combine the
results with the least common multiple operation. Now the order of a wrt.
to p^k must divide Φ(p^k). Call this number t, and determine it's factors
q^e. Since each multiple of the order will also yield 1 when used as
exponent for a, it's enough to find the least d such that (q^d)*(t/(q^e))
yields 1 when used as exponent.
=#
multiplicativeorder(a::Integer, m::Integer) = multiplicativeorder(promote(a, m)...)
multiplicativeorder(a::T, m::T) where {T<:Integer} = begin
    iscoprime(a, m) || error("$a and $m are not coprime")

    res = one(m)
    for (p, k) in factor(m)
        m = p^k
        t = (m ÷ p) * (p-1)
        for f in factors(t)
            if powermod(a, f, m) == 1
                res = lcm(res, f)
                break
            end
        end
    end
    res
end

##  Solve linear modulo equation a * x = b mod m
# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
linearmod(a::Integer, b::Integer, m::Integer) = linearmod(promote(a, b, m)...)
linearmod(a::T, b::T, m::T) where {T<:Integer} = begin
    m > 1 || error("Argument 'm' must be an integer greater 1")

    g, u, v = gcdx(a, m)
    mod(b, g) == 0 || return T[]

    x0 = mod(u * (b ÷ g), m)
    [mod(x0 + i * (m ÷ g), m) for i in 0:(g-1)]
end

##  Find a primitive root modulo m
# https://github.com/hwborchers/Numbers.jl/blob/master/src/primes.jl
primitiveroot(m::T) where {T<:Integer} = begin
    isprime(m) || error("Argument 'm' must be a prime number")
    m == 2 && return one(T)

    P = primefactors(m-1)
    for r in 2:(m-1)
        not_found = true
        for p in P
            if powermod(r, (m-1) ÷ p, m) == 1
                not_found = false
                break
            end
        end
        not_found && return r
    end
    zero(T)
end
