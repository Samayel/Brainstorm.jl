export
    divisorcount, divisorsigma,
    isperfect, isdeficient, isabundant,
    factorsort, invfactor,
    least_number_with_d_divisors

# https://oeis.org/wiki/Divisor_function
divisorcount(n::Integer) = begin
    n <= 0 && throw(DomainError())

    c = 1
    for ex in values(yfactor(n))
        c *= ex + 1
    end
    c
end
divisorsigma(n::Integer, k = 1) = begin
    ((k < 0) || (n <= 0)) && throw(DomainError())
    n == 1 && return 1
    k == 0 && return divisorcount(n)

    σ = 1
    for (p, ex) in yfactor(n)
        σ *= div(p^((ex + 1) * k) - 1, p^k - 1)
    end
    σ
end

isperfect(n::Integer) = divisorsigma(n, 1) - n == n
isdeficient(n::Integer) = divisorsigma(n, 1) - n < n
isabundant(n::Integer) = divisorsigma(n, 1) - n > n

factorsort(n::Integer) = yfactor(n) |> SortedDict
invfactor{T<:Integer}(x::Array{T,1}) =
    [big(nthprime(i))^ex for (i, ex) = enumerate(x)] |> prod

# http://www.primepuzzles.net/problems/prob_019.htm
least_number_with_d_divisors(d::Integer) =
    @pipe least_number_with_d_divisors_exponents(d) |>
    imap(invfactor, _) |>
    minimum

function least_number_with_d_divisors_exponents{T<:Integer}(d::T, i::Int = 1, prevn::T = 0)
    d <= 1 && return Any[Integer[]]

    f = factorsort(d)
    pmax = last(f)[1]
    k = sum(values(f))

    p = nthprime(k+i-1)
    p_i = nthprime(i)
    m = floor(Integer, log(p) / log(p_i))

    c = [pmax]
    for b = 2:m
        !(b in keys(f)) && continue

        for a = b:m
            a*b <= pmax && continue
            d % (a*b) != 0 && continue
            first(factorsort(a))[1] < b && continue
            i > 1 && a*b > prevn && continue

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

    return i == 1 ? [reverse(x) for x in ans] : ans
end
