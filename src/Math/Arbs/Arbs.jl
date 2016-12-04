
# joinpath(Pkg.dir("Brainstorm"), "src", "Math", "Arbs") |> cd



import Base: one, show, zero

using Nemo
using Nemo: _arb_set, arf_struct

typealias Fslong Int
typealias Fulong UInt

const WORD_MAX = typemax(Fslong)
const WORD_MIN = typemin(Fslong)
const UWORD_MAX = typemax(Fulong)
const UWORD_MIN = typemin(Fulong)

typealias fmpr_rnd_t Cint

const FMPR_RND_DOWN = 0
const FMPR_RND_UP = 1
const FMPR_RND_FLOOR = 2
const FMPR_RND_CEIL = 3
const FMPR_RND_NEAR = 4

typealias arb_t arb

include("arf.jl")
include("arf_interval.jl")
include("arb.jl")
include("arb_calc.jl")





# func(x, o) = begin
#     α = sin(x)
#     β = (o > 1) ? cos(x) : zero(x)
#     α, β
# end

# r = arf_interval()
# start = arf_interval()
# arf_set_si(start.a, 1)
# arf_set_si(start.b, 4)

# iter = 100
# prec = 512
# arbParent = ArbField(prec)

# res = arb_calc_refine_root_bisect(r, func, start, iter, arbParent)
# arf_interval_printd(r, 1000)

# a, b = ArbField(2*prec)(), ArbField(2*prec)()
# arb_set_arf(a, r.a)
# arb_set_arf(b, r.b)
# [sin(a), sin(b)]
