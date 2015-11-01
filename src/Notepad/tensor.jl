
# https://github.com/JuliaLang/julia/issues/13333#issuecomment-143597032

module TensorOperators

export ++, ⊗, ⊕

++(A::AbstractArray, B::AbstractArray) = vcat(A, B)
const ⊕ = ++

⊗(A::AbstractArray, B::AbstractArray) = kron(A, B)

end



using TensorOperators
([1,2,3] ++ [4,5,6]) ⊗ [1 2 3 4 5 6]

#=
6x6 Array{Int64,2}:
 1   2   3   4   5   6
 2   4   6   8  10  12
 3   6   9  12  15  18
 4   8  12  16  20  24
 5  10  15  20  25  30
 6  12  18  24  30  36
=#
