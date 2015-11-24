@reexport module MPFR

import Brainstorm.Math.GMP: set!, add!, mul!, sub!, neg!, pow!, lsh!, rsh!

export fma!, sqrt!, exp!, exp2!, exp10!, precision!

import Base.GMP: ClongMax, CulongMax, CdoubleMax
import Base.MPFR: ROUNDING_MODE

function set!(x::BigFloat, y::BigFloat)
    ccall((:mpfr_set, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &y, ROUNDING_MODE[end])
    return x
end
function set!(x::BigFloat, y::BigInt)
    ccall((:mpfr_set_z, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigInt}, Int32), &x, &y, ROUNDING_MODE[end])
    return x
end
function set!(x::BigFloat, y::Clong)
    ccall((:mpfr_set_si, :libmpfr), Int32, (Ptr{BigFloat}, Clong, Int32), &x, y, ROUNDING_MODE[end])
    return x
end
function set!(x::BigFloat, y::Culong)
    ccall((:mpfr_set_ui, :libmpfr), Int32, (Ptr{BigFloat}, Culong, Int32), &x, y, ROUNDING_MODE[end])
    return x
end
function set!(x::BigFloat, y::Float64)
    ccall((:mpfr_set_d, :libmpfr), Int32, (Ptr{BigFloat}, Float64, Int32), &x, y, ROUNDING_MODE[end])
    return x
end

set!(x::BigFloat, y::Integer) = set!(x, BigInt(y))

set!(x::BigFloat, y::Union{Bool,Int8,Int16,Int32}) = set!(x, convert(Clong, y))
set!(x::BigFloat, y::Union{UInt8,UInt16,UInt32}) = set!(x, convert(Culong, y)) 

set!(x::BigFloat, y::Union{Float16,Float32}) = set!(x, Float64(y))


# Basic arithmetic without promotion
for (fJ, fC) in ((:add!,:add), (:mul!,:mul))
    @eval begin
        # BigFloat
        function ($fJ)(x::BigFloat, y::BigFloat)
            ccall(($(string(:mpfr_,fC)),:libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, &y, ROUNDING_MODE[end])
            return x
        end

        # Unsigned Integer
        function ($fJ)(x::BigFloat, c::CulongMax)
            ccall(($(string(:mpfr_,fC,:_ui)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, c, ROUNDING_MODE[end])
            return x
        end
        ($fJ)(c::CulongMax, x::BigFloat) = ($fJ)(x,c)

        # Signed Integer
        function ($fJ)(x::BigFloat, c::ClongMax)
            ccall(($(string(:mpfr_,fC,:_si)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, c, ROUNDING_MODE[end])
            return x
        end
        ($fJ)(c::ClongMax, x::BigFloat) = ($fJ)(x,c)

        # Float32/Float64
        function ($fJ)(x::BigFloat, c::CdoubleMax)
            ccall(($(string(:mpfr_,fC,:_d)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Cdouble, Int32), &x, &x, c, ROUNDING_MODE[end])
            return x
        end
        ($fJ)(c::CdoubleMax, x::BigFloat) = ($fJ)(x,c)

        # BigInt
        function ($fJ)(x::BigFloat, c::BigInt)
            ccall(($(string(:mpfr_,fC,:_z)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigInt}, Int32), &x, &x, &c, ROUNDING_MODE[end])
            return x
        end
        ($fJ)(c::BigInt, x::BigFloat) = ($fJ)(x,c)
    end
end


# div! should be integer division: for (fJ, fC) in ((:sub!,:sub), (:div!,:div))
for (fJ, fC) in ((:sub!,:sub),)
    @eval begin
        # BigFloat
        function ($fJ)(x::BigFloat, y::BigFloat)
            ccall(($(string(:mpfr_,fC)),:libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, &y, ROUNDING_MODE[end])
            return x
        end

        # Unsigned Int
        function ($fJ)(x::BigFloat, c::CulongMax)
            ccall(($(string(:mpfr_,fC,:_ui)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, c, ROUNDING_MODE[end])
            return x
        end
        function ($fJ)(c::CulongMax, x::BigFloat)
            ccall(($(string(:mpfr_,:ui_,fC)), :libmpfr), Int32, (Ptr{BigFloat}, Culong, Ptr{BigFloat}, Int32), &x, c, &x, ROUNDING_MODE[end])
            return x
        end

        # Signed Integer
        function ($fJ)(x::BigFloat, c::ClongMax)
            ccall(($(string(:mpfr_,fC,:_si)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, c, ROUNDING_MODE[end])
            return x
        end
        function ($fJ)(c::ClongMax, x::BigFloat)
            ccall(($(string(:mpfr_,:si_,fC)), :libmpfr), Int32, (Ptr{BigFloat}, Clong, Ptr{BigFloat}, Int32), &x, c, &x, ROUNDING_MODE[end])
            return x
        end

        # Float32/Float64
        function ($fJ)(x::BigFloat, c::CdoubleMax)
            ccall(($(string(:mpfr_,fC,:_d)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Cdouble, Int32), &x, &x, c, ROUNDING_MODE[end])
            return x
        end
        function ($fJ)(c::CdoubleMax, x::BigFloat)
            ccall(($(string(:mpfr_,:d_,fC)), :libmpfr), Int32, (Ptr{BigFloat}, Cdouble, Ptr{BigFloat}, Int32), &x, c, &x, ROUNDING_MODE[end])
            return x
        end

        # BigInt
        function ($fJ)(x::BigFloat, c::BigInt)
            ccall(($(string(:mpfr_,fC,:_z)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigInt}, Int32), &x, &x, &c, ROUNDING_MODE[end])
            return x
        end
        # no :mpfr_z_div function
    end
end

function sub!(c::BigInt, x::BigFloat)
    ccall((:mpfr_z_sub, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigInt}, Ptr{BigFloat}, Int32), &x, &c, &x, ROUNDING_MODE[end])
    return x
end


function fma!(x::BigFloat, y::BigFloat, z::BigFloat)
    ccall(("mpfr_fma",:libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, &y, &z, ROUNDING_MODE[end])
    return x
end

function neg!(x::BigFloat)
    ccall((:mpfr_neg, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, ROUNDING_MODE[end])
    return x
end


function sqrt!(x::BigFloat)
    isnan(x) && return x
    ccall((:mpfr_sqrt, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, ROUNDING_MODE[end])
    if isnan(x)
        throw(DomainError())
    end
    return x
end

sqrt!(x::BigInt) = sqrt!(BigFloat(x))


function pow!(x::BigFloat, y::BigFloat)
    ccall((:mpfr_pow, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, &y, ROUNDING_MODE[end])
    return x
end

function pow!(x::BigFloat, y::CulongMax)
    ccall((:mpfr_pow_ui, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, y, ROUNDING_MODE[end])
    return x
end

function pow!(x::BigFloat, y::ClongMax)
    ccall((:mpfr_pow_si, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, y, ROUNDING_MODE[end])
    return x
end

function pow!(x::BigFloat, y::BigInt)
    ccall((:mpfr_pow_z, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigInt}, Int32), &x, &x, &y, ROUNDING_MODE[end])
    return x
end


for f in (:exp!, :exp2!, :exp10!)
    @eval function $f(x::BigFloat)
        ccall(($(string(:mpfr_,f)), :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Int32), &x, &x, ROUNDING_MODE[end])
        return x
    end
end


function lsh!(x::BigFloat, n::Clong)
    ccall((:mpfr_mul_2si, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, n, ROUNDING_MODE[end])
    return x
end
function lsh!(x::BigFloat, n::Culong)
    ccall((:mpfr_mul_2ui, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, n, ROUNDING_MODE[end])
    return x
end
lsh!(x::BigFloat, n::ClongMax) = lsh!(x, convert(Clong, n))
lsh!(x::BigFloat, n::CulongMax) = lsh!(x, convert(Culong, n))

function rsh!(x::BigFloat, n::Clong)
    ccall((:mpfr_div_2si, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Clong, Int32), &x, &x, n, ROUNDING_MODE[end])
    return x
end
function rsh!(x::BigFloat, n::Culong)
    ccall((:mpfr_div_2ui, :libmpfr), Int32, (Ptr{BigFloat}, Ptr{BigFloat}, Culong, Int32), &x, &x, n, ROUNDING_MODE[end])
    return x
end
rsh!(x::BigFloat, n::ClongMax) = rsh!(x, convert(Clong, n))
rsh!(x::BigFloat, n::CulongMax) = rsh!(x, convert(Culong, n))


precision!(x::BigFloat, y::Int) = begin
    ccall((:mpfr_prec_round, :libmpfr), Int32, (Ptr{BigFloat}, Clong, Int32), &x, y, ROUNDING_MODE[end])
    return x
end

end
