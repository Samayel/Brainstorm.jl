
################################################################################
#
#  Types and memory management for arf_interval
#
################################################################################

immutable arf_interval_struct
    a::arf_t
    b::arf_t

    arf_interval_struct() = new(arf(), arf())
    arf_interval_struct(a::arf_t, b::arf_t) = new(a, b)
end

typealias arf_interval_t arf_interval_struct
typealias arf_interval_ptr Vector{arf_interval_t}
typealias arf_interval_srcptr arf_interval_ptr

arf_interval() = arf_interval_struct()
arf_interval(a::arf_t, b::arf_t) = arf_interval_struct(a, b)

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
        arf_interval_set(v::($typeofv), u::arf_interval_t)  = (arf_set(v.a, u.a); arf_set(v.b, u.b))
        arf_interval_swap(v::($typeofv), u::arf_interval_t) = (arf_swap(v.a, u.a); arf_swap(v.b, u.b))
    end
end

arf_interval_get_arb(x::arb_t, v::arf_interval_t, prec) = arb_set_interval_arf(x, v.a, v.b, prec)
