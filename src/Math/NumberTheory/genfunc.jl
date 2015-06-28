export
    expand_maclaurin_series,
    coefficient, coefficients

expand_maclaurin_series{T<:Number}(genfunc, order::Integer, ::Type{T} = Int) =
    @pipe affine(0, order) |>
    genfunc |>
    convert(Taylor1{T}, _)

coefficient{T<:Number}(series::Taylor1{T}, k::Integer) = get_coeff(series, k)
coefficients{T<:Number}(series::Taylor1{T}) = [coefficient(series, k) for k = 0:length(series)]

affine(z, k) = z + taylor1_variable(typeof(z), k)
