export
    divisorcount, divisorsigma,
    isperfect, isdeficient, isabundant,
    primefactors, primefactors_sorted,
    factorization_sorted,
    least_number_with_d_divisors

# https://oeis.org/wiki/Divisor_function
divisorcount(n::Integer) = begin
    n <= 0 && throw(DomainError())

    c = 1
    for k in values(factorization(n))
        c *= k + 1
    end
    c
end
divisorsigma(n::Integer, s = 1) = begin
    ((s < 0) || (n <= 0)) && throw(DomainError())
    n == 1 && return 1
    s == 0 && return divisorcount(n)

    σ = 1
    for (p, k) in factorization(n)
        σ *= div(p^((k + 1) * s) - 1, p^s - 1)
    end
    σ
end

isperfect(n::Integer) = divisorsigma(n, 1) - n == n
isdeficient(n::Integer) = divisorsigma(n, 1) - n < n
isabundant(n::Integer) = divisorsigma(n, 1) - n > n

primefactors(n::Integer) = factorization(n) |> keys |> collect
primefactors_sorted(n::Integer) = primefactors(n) |> sort

factorization_sorted(n::Integer) = factorization(n) |> SortedDict

function indexfactorization2number{T<:Integer}(x::Array{T,1})
    [big(nthprime(i))^k for (i, k) = enumerate(x)] |> prod
end

# http://www.primepuzzles.net/problems/prob_019.htm
least_number_with_d_divisors(d::Integer) =
    @pipe least_number_with_d_divisors_exponents(d) |>
    imap(indexfactorization2number, _) |>
    minimum

function least_number_with_d_divisors_exponents{T<:Integer}(d::T, i::Int = 1, prevn::T = 0)
    d <= 1 && return Any[Integer[]]

    f = factorization_sorted(d)
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
            first(primefactors_sorted(a)) < b && continue
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
