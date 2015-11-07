module Test

using Base.Test
# using Lint.lintpkg

include("Meta/meta.jl")
include("DataStructure/datastructure.jl")
include("Algorithm/algorithm.jl")
include("Math/math.jl")
include("Finance/finance.jl")

function test()
    Meta.test_all()
    DataStructure.test_all()
    Algorithm.test_all()
    Math.test_all()
    Finance.test_all()

    println("")

    # @test isempty(lintpkg("Brainstorm", returnMsgs=true))
    # lintpkg("Brainstorm", returnMsgs=true)
end

end
