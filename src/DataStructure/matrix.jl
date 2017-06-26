export
    rows, cols, diags, antidiags

rows(m::AbstractArray{T,2}) where {T} = [vec(m[i,:]) for i in 1:size(m, 1)]
cols(m::AbstractArray{T,2}) where {T} = [vec(m[:,j]) for j in 1:size(m, 2)]
diags(m::AbstractArray{T,2}) where {T} = [diag(m, k) for k in (1 - size(m, 1)):(size(m, 2) - 1)]
antidiags(m::AbstractArray{T,2}) where {T} = rotl90(m) |> diags
