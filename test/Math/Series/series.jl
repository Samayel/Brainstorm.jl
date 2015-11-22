module Series

using Brainstorm
using Base.Test

include("sqrt.jl")
include("arctan.jl")
include("pi.jl")
include("euler.jl")
include("ln2.jl")

function test_all()
    test_sqrt_all()
    test_arctan_all()
    test_pi_all()
    test_euler_all()
    test_ln2_all()
end

end
