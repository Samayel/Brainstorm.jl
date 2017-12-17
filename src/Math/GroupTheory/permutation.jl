export PermutationGroup, perm, circshift!, swap!

swap!(p::Nemo.Generic.perm, i::Integer, j::Integer) = (t = p[i]; p[i] = p[j]; p[j] = t)
circshift!(p::Nemo.Generic.perm, k::Integer) = (t = copy(p.d); circshift!(p.d, t, k))

getindex(x::AbstractArray, p::Nemo.Generic.perm) = x[p.d]
