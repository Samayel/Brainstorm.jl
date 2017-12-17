export PermutationGroup, perm, apply, circshift!, swap!

swap!(p::Nemo.Generic.perm, i::Integer, j::Integer) = (t = p[i]; p[i] = p[j]; p[j] = t)
circshift!(p::Nemo.Generic.perm, k::Integer) = (t = copy(p.d); circshift!(p.d, t, k))

apply(p::Nemo.Generic.perm, x) = x[p.d]
