# http://numbers.computation.free.fr/Constants/Algorithms/splitting.html

binarysplitting(a, b) = begin
    # directly compute P(a, a + 1), Q(a, a + 1) and T(a, a + 1)
    (b - a) == 1 && return compute(a, b)

    # recursively compute P(a, b), Q(a, b) and T(a, b)

    # m is the midpoint of a and b
    m = (a + b) >>> 1

    # recursively calculate P(a, m), Q(a, m) and T(a, m)
    am = binarysplitting(a, m)
    # recursively calculate P(m, b), Q(m, b) and T(m, b)
    mb = binarysplitting(m, b)

    # now combine
    combine(am, mb)
end

binarysplitting!(s, a, b) = begin
    # directly compute P(a, a + 1), Q(a, a + 1) and T(a, a + 1)
    (b - a) == 1 && (compute!(s, a, b); return)

    # recursively compute P(a, b), Q(a, b) and T(a, b)

    # m is the midpoint of a and b
    m = (a + b) >>> 1

    # recursively calculate P(a, m), Q(a, m) and T(a, m)
    binarysplitting!(s, a, m)

    # recursively calculate P(m, b), Q(m, b) and T(m, b)
    push!(s)
    binarysplitting!(s, m, b)
    pop!(s)

    # now combine
    combine!(s)
    return
end
