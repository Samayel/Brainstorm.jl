
################################################################################
#
#  Types and memory management for arb
#
################################################################################

# typealias arb_t arb
typealias arb_ptr Vector{arb_t}
typealias arb_srcptr arb_ptr

###############################################################################
#
#   Basic manipulation
#
###############################################################################

zero(x::arb) = parent(x)(0)
one(x::arb) = parent(x)(1)

arb_rel_accuracy_bits(x::arb_t) = accuracy_bits(x)

arb_bits(x::arb_t) = ccall((:arb_bits, :libarb), Fslong, (Ref{arb_t}, ), x)

################################################################################
#
#  String I/O
#
################################################################################

arb_printn(x::arb_t, digits, flags = 0) = ccall((:arb_printn, :libarb), Void, (Ref{arb_t}, Fslong, Fulong), x, digits, flags)

################################################################################
#
#  Predicates
#
################################################################################

arb_is_zero(x::arb_t) = iszero(x)
arb_is_nonzero(x::arb_t) = isnonzero(x)
arb_is_one(x::arb_t) = isone(x)

arb_is_finite(x::arb_t) = isfinite(x)
arb_is_exact(x::arb_t) = isexact(x)
arb_is_int(x::arb_t) = isint(x)

arb_is_positive(x::arb_t) = ispositive(x)
arb_is_nonnegative(x::arb_t) = isnonnegative(x)
arb_is_negative(x::arb_t) = isnegative(x)
arb_is_nonpositive(x::arb_t) = isnonpositive(x)

arb_contains_zero(x::arb_t) = Bool(ccall((:arb_contains_zero, :libarb), Cint, (Ref{arb_t}, ), x))
arb_contains_negative(x::arb_t) = Bool(ccall((:arb_contains_negative, :libarb), Cint, (Ref{arb_t}, ), x))
arb_contains_nonpositive(x::arb_t) = Bool(ccall((:arb_contains_nonpositive, :libarb), Cint, (Ref{arb_t}, ), x))
arb_contains_positive(x::arb_t) = Bool(ccall((:arb_contains_positive, :libarb), Cint, (Ref{arb_t}, ), x))
arb_contains_nonnegative(x::arb_t) = Bool(ccall((:arb_contains_nonnegative, :libarb), Cint, (Ref{arb_t}, ), x))

################################################################################
#
#  Unsafe setting
#
################################################################################

for (typeofy, passtoc) in ((arb_t, Ref{arb_t}), (Ptr{arb_t}, Ptr{arb_t}))
    @eval begin
        arb_set(y::($typeofy), x::arb_t) = _arb_set(y, x)
        arb_set_round(y::($typeofy), x::arb_t, prec) = _arb_set(y, x, prec)
        arb_set_si(y::($typeofy), x::Fslong) = _arb_set(y, x)
        arb_set_ui(y::($typeofy), x::Fulong) = _arb_set(y, x)
        arb_set_d(y::($typeofy), x::Cdouble) = _arb_set(y, x)
        arb_set_fmpz(y::($typeofy), x::fmpz) = _arb_set(y, x)
        arb_set_round_fmpz(y::($typeofy), x::fmpz, prec) = _arb_set(y, x, prec)
        arb_set_fmpq(y::($typeofy), x::fmpq, prec) = _arb_set(y, x, prec)
        arb_set_str(y::($typeofy), x::AbstractString, prec) = _arb_set(y, x, prec)

        arb_set_arf(y::($typeofy), x::arf_t) =  ccall((:arb_set_arf, :libarb), Void, (($passtoc), Ref{arf_t}), y, x)
        arb_set_interval_arf(x::($typeofy), a::arf_t, b::arf_t, prec) = ccall((:arb_set_interval_arf, :libarb), Void, (($passtoc), Ref{arf_t}, Ref{arf_t}, Fslong), x, a, b, prec)
    end
end
