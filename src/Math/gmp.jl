@reexport module GMP

import Base.GMP: ClongMax, CulongMax, CdoubleMax
import Brainstorm.Math: add!, sub!, mul!

export
    set!,
    fld!, div!, mod!, rem!,
    gcd!, lcm!, and!, or!, xor!,
    neg!, com!,
    lsh!, rsh!,
    pow!, isqrt!

function set!(x::BigInt, y::BigInt)
    ccall((:__gmpz_set, :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}), &x, &y)
    return x
end
function set!(x::BigInt, y::ClongMax)
    ccall((:__gmpz_set_si, :libgmp), Void, (Ptr{BigInt}, Clong), &x, y)
    return x
end
function set!(x::BigInt, y::CulongMax)
    ccall((:__gmpz_set_ui, :libgmp), Void, (Ptr{BigInt}, Culong), &x, y)
    return x
end
set!(x::BigInt, y::Integer) = set!(x, convert(BigInt, y))

# Binary ops
for (fJ, fC) in ((:add!, :add), (:sub!,:sub), (:mul!, :mul),
                 (:fld!, :fdiv_q), (:div!, :tdiv_q), (:mod!, :fdiv_r), (:rem!, :tdiv_r),
                 (:gcd!, :gcd), (:lcm!, :lcm),
                 (:and!, :and), (:or!, :ior), (:xor!, :xor))
    @eval begin
        function ($fJ)(x::BigInt, y::BigInt)
            ccall(($(string(:__gmpz_,fC)), :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}, Ptr{BigInt}), &x, &x, &y)
            return x
        end
    end
end

# unary ops
for (fJ, fC) in ((:neg!, :neg), (:com!, :com))
    @eval begin
        function ($fJ)(x::BigInt)
            ccall(($(string(:__gmpz_,fC)), :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}), &x, &x)
            return x
        end
    end
end

function lsh!(x::BigInt, c::CulongMax)
    c < 0 && throw(DomainError())
    c == 0 && return x
    ccall((:__gmpz_mul_2exp, :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}, Culong), &x, &x, c)
    return x
end
lsh!(x::BigInt, c::Integer) = lsh!(x, convert(Culong, c))

function rsh!(x::BigInt, c::CulongMax)
    c < 0 && throw(DomainError())
    c == 0 && return x
    ccall((:__gmpz_fdiv_q_2exp, :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}, Culong), &x, &x, c)
    return x
end
rsh!(x::BigInt, c::Integer) = rsh!(x, convert(Culong, c))

function isqrt!(x::BigInt)
    ccall((:__gmpz_sqrt, :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}), &x, &x)
    return x
end

function pow!(x::BigInt, y::CulongMax)
    ccall((:__gmpz_pow_ui, :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}, Culong), &x, &x, y)
    return x
end
pow!(x::BigInt, c::Integer) = pow!(x, convert(Culong, c))

# Basic arithmetic without promotion
function add!(x::BigInt, c::CulongMax)
    ccall((:__gmpz_add_ui, :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}, Culong), &x, &x, c)
    return x
end
add!(c::CulongMax, x::BigInt) = add!(x, c)

function sub!(x::BigInt, c::CulongMax)
    ccall((:__gmpz_sub_ui, :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}, Culong), &x, &x, c)
    return x
end
function sub!(c::CulongMax, x::BigInt)
    ccall((:__gmpz_ui_sub, :libgmp), Void, (Ptr{BigInt}, Culong, Ptr{BigInt}), &x, c, &x)
    return x
end

add!(x::BigInt, c::ClongMax) = c < 0 ? sub!(x, -(c % Culong)) : add!(x, convert(Culong, c))
add!(c::ClongMax, x::BigInt) = c < 0 ? sub!(x, -(c % Culong)) : add!(x, convert(Culong, c))
sub!(x::BigInt, c::ClongMax) = c < 0 ? add!(x, -(c % Culong)) : sub!(x, convert(Culong, c))
sub!(c::ClongMax, x::BigInt) = c < 0 ? neg!(add!(x, -(c % Culong))) : sub!(convert(Culong, c), x)

add!(x::BigInt, c::Integer) = add!(x, convert(BigInt, c))
add!(c::Integer, x::BigInt) = add!(convert(BigInt, c), x)
sub!(x::BigInt, c::Integer) = sub!(x, convert(BigInt, c))
sub!(c::Integer, x::BigInt) = sub!(convert(BigInt, c), x)

function mul!(x::BigInt, c::CulongMax)
    ccall((:__gmpz_mul_ui, :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}, Culong), &x, &x, c)
    return x
end
mul!(c::CulongMax, x::BigInt) = mul!(x, c)

function mul!(x::BigInt, c::ClongMax)
    ccall((:__gmpz_mul_si, :libgmp), Void, (Ptr{BigInt}, Ptr{BigInt}, Clong), &x, &x, c)
    return x
end
mul!(c::ClongMax, x::BigInt) = mul!(x, c)

mul!(x::BigInt, c::Integer) = mul!(x, convert(BigInt, c))
mul!(c::Integer, x::BigInt) = mul!(convert(BigInt, c), x)

end
