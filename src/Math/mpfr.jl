@reexport module MPFR

import Base.GMP: ClongMax, CulongMax, CdoubleMax
import Base.MPFR: ROUNDING_MODE
import Brainstorm.Math.GMP: set!, add!, mul!, sub!, neg!, pow!, lsh!, rsh!

export fma!, sqrt!, exp!, exp2!, exp10!, precision!

function set!(x::BigFloat, y::BigFloat)
    ccall((:mpfr_set, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &y, ROUNDING_MODE[])
    return x
end
function set!(x::BigFloat, y::BigInt)
    ccall((:mpfr_set_z, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigInt}, Int32), &x, &y, ROUNDING_MODE[])
    return x
end
function set!(x::BigFloat, y::ClongMax)
    ccall((:mpfr_set_si, :libmpfr), Int32, (Ptr{BigFloat}, Clong, Int32), &x, y, ROUNDING_MODE[])
    return x
end
function set!(x::BigFloat, y::CulongMax)
    ccall((:mpfr_set_ui, :libmpfr), Int32, (Ptr{BigFloat}, Culong, Int32), &x, y, ROUNDING_MODE[])
    return x
end
function set!(x::BigFloat, y::Float64)
    ccall((:mpfr_set_d, :libmpfr), Int32, (Ptr{BigFloat}, Float64, Int32), &x, y, ROUNDING_MODE[])
    return x
end

set!(x::BigFloat, y::Integer) = set!(x, convert!(BigInt, y))
set!(x::BigFloat, y::Union{Float16,Float32}) = set!(x, Float64(y))


# Basic arithmetic without promotion
for (fJ, fC) in ((:add!,:add), (:mul!,:mul))
    @eval begin
        # BigFloat
        function ($fJ)(x::BigFloat, y::BigFloat)
            ccall(($(string(:mpfr_,fC)),:libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, &y, ROUNDING_MODE[])
            return x
        end

        # Unsigned Integer
        function ($fJ)(x::BigFloat, c::CulongMax)
            ccall(($(string(:mpfr_,fC,:_ui)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, c, ROUNDING_MODE[])
            return x
        end
        ($fJ)(c::CulongMax, x::BigFloat) = ($fJ)(x,c)

        # Signed Integer
        function ($fJ)(x::BigFloat, c::ClongMax)
            ccall(($(string(:mpfr_,fC,:_si)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, c, ROUNDING_MODE[])
            return x
        end
        ($fJ)(c::ClongMax, x::BigFloat) = ($fJ)(x,c)

        # Float32/Float64
        function ($fJ)(x::BigFloat, c::CdoubleMax)
            ccall(($(string(:mpfr_,fC,:_d)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Cdouble, Int32), &x, &x, c, ROUNDING_MODE[])
            return x
        end
        ($fJ)(c::CdoubleMax, x::BigFloat) = ($fJ)(x,c)

        # BigInt
        function ($fJ)(x::BigFloat, c::BigInt)
            ccall(($(string(:mpfr_,fC,:_z)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigInt}, Int32), &x, &x, &c, ROUNDING_MODE[])
            return x
        end
        ($fJ)(c::BigInt, x::BigFloat) = ($fJ)(x,c)

        ($fJ)(x::BigFloat, c::Integer) = ($fJ)(x, convert(BigInt, c))
        ($fJ)(c::Integer, x::BigFloat) = ($fJ)(convert(BigInt, c), x)
    end
end


# div! should be integer division: for (fJ, fC) in ((:sub!,:sub), (:div!,:div))
for (fJ, fC) in ((:sub!,:sub),)
    @eval begin
        # BigFloat
        function ($fJ)(x::BigFloat, y::BigFloat)
            ccall(($(string(:mpfr_,fC)),:libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, &y, ROUNDING_MODE[])
            return x
        end

        # Unsigned Int
        function ($fJ)(x::BigFloat, c::CulongMax)
            ccall(($(string(:mpfr_,fC,:_ui)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, c, ROUNDING_MODE[])
            return x
        end
        function ($fJ)(c::CulongMax, x::BigFloat)
            ccall(($(string(:mpfr_,:ui_,fC)), :libmpfr), Int32, (Ptr{BigFloat}, Culong, Ptr{BigFloat}, Int32), &x, c, &x, ROUNDING_MODE[])
            return x
        end

        # Signed Integer
        function ($fJ)(x::BigFloat, c::ClongMax)
            ccall(($(string(:mpfr_,fC,:_si)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, c, ROUNDING_MODE[])
            return x
        end
        function ($fJ)(c::ClongMax, x::BigFloat)
            ccall(($(string(:mpfr_,:si_,fC)), :libmpfr), Int32, (Ptr{BigFloat}, Clong, Ptr{BigFloat}, Int32), &x, c, &x, ROUNDING_MODE[])
            return x
        end

        # Float32/Float64
        function ($fJ)(x::BigFloat, c::CdoubleMax)
            ccall(($(string(:mpfr_,fC,:_d)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Cdouble, Int32), &x, &x, c, ROUNDING_MODE[])
            return x
        end
        function ($fJ)(c::CdoubleMax, x::BigFloat)
            ccall(($(string(:mpfr_,:d_,fC)), :libmpfr), Int32, (Ptr{BigFloat}, Cdouble, Ptr{BigFloat}, Int32), &x, c, &x, ROUNDING_MODE[])
            return x
        end

        # BigInt
        function ($fJ)(x::BigFloat, c::BigInt)
            ccall(($(string(:mpfr_,fC,:_z)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigInt}, Int32), &x, &x, &c, ROUNDING_MODE[])
            return x
        end
        # no :mpfr_z_div function

        ($fJ)(x::BigFloat, c::Integer) = ($fJ)(x, convert(BigInt, c))
        ($fJ)(c::Integer, x::BigFloat) = ($fJ)(convert(BigInt, c), x)
    end
end

function sub!(c::BigInt, x::BigFloat)
    ccall((:mpfr_z_sub, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigInt}, Ptr{BigFloat}, Int32), &x, &c, &x, ROUNDING_MODE[])
    return x
end


function fma!(x::BigFloat, y::BigFloat, z::BigFloat)
    ccall(("mpfr_fma",:libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, &y, &z, ROUNDING_MODE[])
    return x
end

function neg!(x::BigFloat)
    ccall((:mpfr_neg, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, ROUNDING_MODE[])
    return x
end


function sqrt!(x::BigFloat)
    isnan(x) && return x
    ccall((:mpfr_sqrt, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, ROUNDING_MODE[])
    if isnan(x)
        throw(DomainError())
    end
    return x
end

sqrt!(x::BigInt) = sqrt!(BigFloat(x))


function pow!(x::BigFloat, y::BigFloat)
    ccall((:mpfr_pow, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, &y, ROUNDING_MODE[])
    return x
end

function pow!(x::BigFloat, y::CulongMax)
    ccall((:mpfr_pow_ui, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, y, ROUNDING_MODE[])
    return x
end

function pow!(x::BigFloat, y::ClongMax)
    ccall((:mpfr_pow_si, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, y, ROUNDING_MODE[])
    return x
end

function pow!(x::BigFloat, y::BigInt)
    ccall((:mpfr_pow_z, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigInt}, Int32), &x, &x, &y, ROUNDING_MODE[])
    return x
end

pow!(x::BigFloat, y::Integer) = pow!(x, convert(BigInt, y))


for f in (:exp!, :exp2!, :exp10!)
    @eval function $f(x::BigFloat)
        ccall(($(string(:mpfr_,f)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, ROUNDING_MODE[])
        return x
    end
end


function lsh!(x::BigFloat, n::ClongMax)
    ccall((:mpfr_mul_2si, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, n, ROUNDING_MODE[])
    return x
end
function lsh!(x::BigFloat, n::CulongMax)
    ccall((:mpfr_mul_2ui, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, n, ROUNDING_MODE[])
    return x
end
lsh!(x::BigFloat, n::Integer) = lsh!(x, convert(Clong, n))

function rsh!(x::BigFloat, n::ClongMax)
    ccall((:mpfr_div_2si, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, n, ROUNDING_MODE[])
    return x
end
function rsh!(x::BigFloat, n::CulongMax)
    ccall((:mpfr_div_2ui, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, n, ROUNDING_MODE[])
    return x
end
rsh!(x::BigFloat, n::Integer) = rsh!(x, convert(Clong, n))


precision!(x::BigFloat, y::ClongMax) = begin
    ccall((:mpfr_prec_round, :libmpfr), Int32, (Ptr{BigFloat}, Clong, Int32), &x, y, ROUNDING_MODE[])
    return x
end
precision!(x::BigFloat, y::Integer) = precision!(x, convert(Clong, y))

end
