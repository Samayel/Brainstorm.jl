
# joinpath(Pkg.dir("Brainstorm"), "src", "Math", "Arbs") |> cd



import Base: convert, one, show, zero

using Brainstorm.Math.MPFR: MPFR_RNDD, MPFR_RNDU
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









func(x, o) = begin
    α = sin(x)
    β = o > 1 ? cos(x) : zero(x)
    α, β
end

arbParent = ArbField()

interv = (big(-1.0), big(10.0))
maxdepth = 100
maxeval = 100000
maxfound = 100
iter = 10000

α = arb_calc_isolate_roots(func, interv, maxdepth, maxeval, maxfound, arbParent, true)
β = [arb_calc_refine_root_bisect(func, x, iter, arbParent) for x in α[1]]
γ = [(func(x[1], 1)[1], func(x[2], 1)[1]) for (_, x) in β]
