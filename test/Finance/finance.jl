module _Finance

using Brainstorm._Finance
using Base.Test

include("daycount.jl")
include("cashflow.jl")

function test_all()
    println("")
    test_daycount_all()
    test_cashflow_all()
end

end
