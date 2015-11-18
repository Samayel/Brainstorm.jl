module Constants

using Brainstorm
using Base.Test

include("pi.jl")

function test_all()
    test_pi_all()
end

end
