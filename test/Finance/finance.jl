module Finance

using Brainstorm.Finance
using Base.Test

include("daycount.jl")

function test_all()
    println("")
    test_daycount_all()
end

end
