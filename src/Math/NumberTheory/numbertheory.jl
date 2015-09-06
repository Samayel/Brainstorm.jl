@reexport module NumberTheory

using Brainstorm: flatten, takewhile, @anon
using Brainstorm.Math: checked_add, checked_sub
using AutoHashEquals: @auto_hash_equals
using DataStructures: SortedDict
using Iterators: chain, cycle, drop, imap, take
using Lists: List, ListNode
using TaylorSeries: Taylor1, taylor1_variable, get_coeff
using Pipe: @pipe
using Reexport: @reexport
using Roots: fzeros

import Base: ==
import TaylorSeries: evaluate

@reexport using Digits

include("primes.jl")
include("factor.jl")
include("mod.jl")
include("decimal.jl")
include("fibonacci.jl")
include("hailstone.jl")
include("triangle.jl")
include("pentagon.jl")
include("hexagon.jl")
include("genfunc.jl")
include("confrac.jl")
include("diophantine.jl")

end
