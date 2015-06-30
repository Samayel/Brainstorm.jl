export
    rows, cols, diags, antidiags

rows{T}(m::AbstractArray{T,2}) = [vec(m[i,:]) for i = 1:size(m, 1)]
cols{T}(m::AbstractArray{T,2}) = [vec(m[:,j]) for j = 1:size(m, 2)]
diags{T}(m::AbstractArray{T,2}) = [diag(m, k) for k = (1 - size(m, 1)):(size(m, 2) - 1)]
antidiags{T}(m::AbstractArray{T,2}) = rotl90(m) |> diags
