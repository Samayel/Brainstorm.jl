
typealias arf_rnd_t fmpr_rnd_t

const ARF_RND_DOWN = FMPR_RND_DOWN
const ARF_RND_UP = FMPR_RND_UP
const ARF_RND_FLOOR = FMPR_RND_FLOOR
const ARF_RND_CEIL = FMPR_RND_CEIL
const ARF_RND_NEAR = FMPR_RND_NEAR

const ARF_PREC_EXACT = WORD_MAX

################################################################################
#
#  Types and memory management for arf
#
################################################################################

typealias arf_t arf_struct

arf() = begin
    z = arf_struct(0, 0, 0, 0)
    ccall((:arf_init, :libarb), Void, (Ref{arf_t}, ), z)
    finalizer(z, x -> ccall((:arf_clear, :libarb), Void, (Ref{arf_t}, ), x))
    z
end

################################################################################
#
#  String I/O
#
################################################################################

arf_printd(y::arf_t, d) = ccall((:arf_printd, :libarb), Void, (Ref{arf_t}, Fslong), y, d)

show(io::IO, x::arf_t) = begin
    prec = 256
    d = ceil(Int, prec * 0.30102999566398119521)
    arf_printd(x, d)
end

################################################################################
#
#  Binary operations
#
################################################################################

arf_add(z::arf_t, x::arf_t, y::arf_t, prec, rnd) = ccall((:arf_add, :libarb), Cint, (Ref{arf_t}, Ref{arf_t}, Ref{arf_t}, Fslong, arf_rnd_t), z, x, y, prec, rnd)

################################################################################
#
#  Shifting
#
################################################################################

arf_mul_2exp_si(y::arf_t, x::arf_t, e) = ccall((:arf_mul_2exp_si, :libarb), Void, (Ref{arf_t}, Ref{arf_t}, Fslong), y, x, e)

################################################################################
#
#  Unsafe setting
#
################################################################################

for (typeofy, passtoc) in ((arf_t, Ref{arf_t}), (Ptr{arf_t}, Ptr{arf_t}))
    @eval begin
        arf_set(y::($typeofy), x::arf_t) = ccall((:arf_set, :libarb), Void, (($passtoc), Ref{arf_t}), y, x)
        arf_set_si(y::($typeofy), x::Fslong) = ccall((:arf_set_si, :libarb), Void, (($passtoc), Fslong), y, x)
        arf_set_ui(y::($typeofy), x::Fulong) = ccall((:arf_set_ui, :libarb), Void, (($passtoc), Fulong), y, x)
        arf_set_d(y::($typeofy), x::Cdouble) = ccall((:arf_set_d, :libarb), Void, (($passtoc), Cdouble), y, x)
        arf_set_fmpz(y::($typeofy), x::fmpz) = ccall((:arf_set_fmpz, :libarb), Void, (($passtoc), Ref{fmpz}), y, x)

        arf_swap(y::($typeofy), x::arf_t) = ccall((:arf_swap, :libarb), Void, (($passtoc), Ref{arf_t}), y, x)
    end
end
