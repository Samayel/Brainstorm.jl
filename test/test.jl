module _Test

using Base.Test
# using Lint.lintpkg

include("Meta/meta.jl")
include("DataStructure/datastructure.jl")
include("Algorithm/algorithm.jl")
include("Math/math.jl")
include("Finance/finance.jl")

function test()
    _Meta.test_all()
    _DataStructure.test_all()
    _Algorithm.test_all()
    _Math.test_all()
    _Finance.test_all()

    println("")

    # @test isempty(lintpkg("Brainstorm", returnMsgs=true))
    # lintpkg("Brainstorm", returnMsgs=true)
end

end
