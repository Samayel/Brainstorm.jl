module Series

using Brainstorm
using Base.Test

include("pi.jl")
include("euler.jl")

function test_all()
    test_pi_all()
    test_euler_all()
end

end
