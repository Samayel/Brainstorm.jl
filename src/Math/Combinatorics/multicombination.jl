
Base.combinations{T,U<:Integer}(a::AbstractArray{T,1}, c::AbstractArray{U,1}, k::U) =
    MultisetCombinations{T,U}(a, c, k)

immutable MultisetCombinations{T,U}
    a::AbstractArray{T,1}
    c::AbstractArray{U,1}
    k::U
end

Base.start(c::MultisetCombinations) = begin
    s = [fill(i, c.c[i]) for i in eachindex(c.a)] |> flatten
    c.k <= length(s) ? s[1:c.k] : [length(c.a) + 1]
end

Base.next(c::MultisetCombinations, s) = begin
    combination = [c.a[si] for si in s]
    c.k > 0 || return (combination, [length(c.a) + 1])

    s = copy(s)
    for i = length(s):-1:1
        s[i] += 1
        while s[i] <= length(c.a) && countnz(s .== s[i]) > c.c[s[i]]
            s[i] += 1
        end

        if s[i] <= length(c.a)
            t = [fill(i, c.c[i] - countnz(s .== i)) for i = s[i]:length(c.a)] |> flatten
            if length(t) >= length(s)-i
                s[i+1:end] = t[1:(length(s)-i)]
            else
                s = [length(c.a) + 1]
            end
            break
        end
    end

    (combination, s)
end

Base.done(c::MultisetCombinations, s) = !isempty(s) && s[1] > length(c.a)

Base.eltype(c::MultisetCombinations) = eltype(typeof(c))
Base.eltype{T,U}(::Type{MultisetCombinations{T,U}}) = Array{T,1}

Base.length(c::MultisetCombinations) = begin
    c.k == 0 && return 1

    csum = sum(c.c)
    c.k > csum && return 0
    c.k == csum && return 1

    # http://www.m-hikari.com/ams/ams-2011/ams-17-20-2011/siljakAMS17-20-2011.pdf
    R, z = PowerSeriesRing(ZZ, c.k + 1, "z")
    gf = prod([sum([z^j for j = 0:m]) for m in c.c])
    l = coeff(gf, c.k)

    convert(Int, l)
end
