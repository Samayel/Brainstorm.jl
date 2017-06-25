@reexport module _NumberTheory

import Base: ==
import Primes

using Brainstorm: flatten, takewhile
using Brainstorm._Math: checked_add, checked_sub
using AutoHashEquals: @auto_hash_equals
using DataStructures: SortedDict
using IterTools: chain, cycle, drop, imap, take
using Lists: List, ListNode
using Pipe: @pipe
using Primes: isprime
using Reexport: @reexport

include("primes.jl")
include("factor.jl")
include("mod.jl")
include("decimal.jl")
include("fibonacci.jl")
include("hailstone.jl")
include("triangle.jl")
include("pentagon.jl")
include("hexagon.jl")
include("confrac.jl")
include("diophantine.jl")

end
