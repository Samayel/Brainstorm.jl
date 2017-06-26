
# joinpath(Pkg.dir("Brainstorm"), "src", "Math", "Arbs") |> cd



import Base: convert, one, show, zero

using Brainstorm._Math._MPFR: MPFR_RNDD, MPFR_RNDU
using Nemo
using Nemo: _arb_set, arf_struct

const Fslong = Int
const Fulong = UInt

const WORD_MAX = typemax(Fslong)
const WORD_MIN = typemin(Fslong)
const UWORD_MAX = typemax(Fulong)
const UWORD_MIN = typemin(Fulong)

const fmpr_rnd_t = Cint

const FMPR_RND_DOWN = 0
const FMPR_RND_UP = 1
const FMPR_RND_FLOOR = 2
const FMPR_RND_CEIL = 3
const FMPR_RND_NEAR = 4

const arb_t = arb

include("arf.jl")
include("arf_interval.jl")
include("arb.jl")
include("arb_calc.jl")







#ArbRoots
#- https://github.com/fredrik-johansson/arb/blob/master/examples/real_roots.c
#- https://wiki.sagemath.org/days4schedule?action=AttachFile&do=get&target=witty.pdf

func(x, o) = begin
    α = x^995(x^2 - 9999)^2 - 1
    β = o > 1 ? 4(x^996)(-9999 + x^2) + 995(x^994)(-9999 + x^2)^2 : zero(x)
    α, β
end

arbParent = ArbField(8192)

interv = (big(98.0), big(101.0))
maxdepth = 100
maxeval = 100000
maxfound = 100
iter = 10000

α = arb_calc_isolate_roots(func, interv, maxdepth, maxeval, maxfound, arbParent, true)
β = [arb_calc_refine_root_bisect(func, x, iter, arbParent) for x in α[1]]
γ = [(func(x[1], 1)[1], func(x[2], 1)[1]) for (_, x) in β]
