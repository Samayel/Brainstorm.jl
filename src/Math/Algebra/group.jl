# TODO: improve! => http://sagenb.org/src/groups/generic.py
log{T<:GroupElem}(a::T, base::T, ord::ZZ) = log(a, base, BigInt(ord))
log{T<:GroupElem}(a::T, base::T, ord::Integer) = begin
    n = 1
    b = base
    while a != b
        n += 1
        b *= base
    end
    n
end
