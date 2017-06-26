
################################################################################
#
#  Types and memory management for arf_interval
#
################################################################################

struct arf_interval_struct
    a::arf_t
    b::arf_t

    arf_interval_struct() = new(arf(), arf())
    arf_interval_struct(a::arf_t, b::arf_t) = new(a, b)
end

const arf_interval_t = arf_interval_struct
const arf_interval_ptr = Vector{arf_interval_t}
const arf_interval_srcptr = arf_interval_ptr

arf_interval() = arf_interval_struct()
arf_interval(a::arf_t, b::arf_t) = arf_interval_struct(a, b)

################################################################################
#
#  Conversions
#
################################################################################

convert(::Type{arf_interval_struct}, x) = arf_interval(convert(arf_struct, x[1]), convert(arf_struct, x[2]))
convert(::Type{arf_interval_struct}, x::arf_interval_struct) = x

convert(::Type{Tuple{T,S}}, x::arf_interval_struct) where {T,S}   = (convert(T, x.a), convert(S, x.b))
convert(::Type{Vector{T}}, x::arf_interval_struct) where {T}      = [convert(T, x.a), convert(T, x.b)]

convert(::Type{Tuple{Fslong,Fslong}}, x::arf_interval_struct)     = (convert(Fslong, x.a, ARF_RND_DOWN), convert(Fslong, x.b, ARF_RND_UP))
convert(::Type{Vector{Fslong}}, x::arf_interval_struct)           = [convert(Fslong, x.a, ARF_RND_DOWN), convert(Fslong, x.b, ARF_RND_UP)]

convert(::Type{Tuple{Cdouble,Cdouble}}, x::arf_interval_struct)   = (convert(Cdouble, x.a, ARF_RND_DOWN), convert(Cdouble, x.b, ARF_RND_UP))
convert(::Type{Vector{Cdouble}}, x::arf_interval_struct)          = [convert(Cdouble, x.a, ARF_RND_DOWN), convert(Cdouble, x.b, ARF_RND_UP)]

convert(::Type{Tuple{BigFloat,BigFloat}}, x::arf_interval_struct) = (convert(BigFloat, x.a, MPFR_RNDD), convert(BigFloat, x.b, MPFR_RNDU))
convert(::Type{Vector{BigFloat}}, x::arf_interval_struct)         = [convert(BigFloat, x.a, MPFR_RNDD), convert(BigFloat, x.b, MPFR_RNDU)]

convert(::Type{Tuple{BigInt,BigInt}}, x::arf_interval_struct)     = (floor(BigInt, convert(BigFloat, x.a, MPFR_RNDD)), ceil(BigInt, convert(BigFloat, x.b, MPFR_RNDU)))
convert(::Type{Vector{BigInt}}, x::arf_interval_struct)           = [floor(BigInt, convert(BigFloat, x.a, MPFR_RNDD)), ceil(BigInt, convert(BigFloat, x.b, MPFR_RNDU))]

################################################################################
#
#  String I/O
#
################################################################################

arf_interval_printd(v::arf_interval_t, n) = begin
    print("[")
    arf_printd(v.a, n)
    print(", ")
    arf_printd(v.b, n)
    print("]")
end

show(io::IO, x::arf_interval_t) = begin
    prec = 256
    d = ceil(Int, prec * 0.30102999566398119521)
    arf_interval_printd(x, d)
end

################################################################################
#
#  Unsafe setting
#
################################################################################

for typeofv in (arf_interval_t, Ptr{arf_interval_t})
    @eval begin
        arf_interval_set(v::($typeofv), u::arf_interval_t)  = (arf_set(v.a, u.a);  arf_set(v.b, u.b))
        arf_interval_swap(v::($typeofv), u::arf_interval_t) = (arf_swap(v.a, u.a); arf_swap(v.b, u.b))
    end
end

arf_interval_get_arb(x::arb_t, v::arf_interval_t, prec) = arb_set_interval_arf(x, v.a, v.b, prec)
