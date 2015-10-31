module Test

using Base.Test
# using Lint.lintpkg

include("Algorithm/algorithm.jl")
include("DataStructure/datastructure.jl")
include("Math/math.jl")
include("Meta/meta.jl")

function test()
    Algorithm.test_all()
    DataStructure.test_all()
    Math.test_all()
    Meta.test_all()
    println("")

    # @test isempty(lintpkg("Brainstorm", returnMsgs=true))
    # lintpkg("Brainstorm", returnMsgs=true)
end

end
