module Algorithm

using Brainstorm.Algorithm
using Base.Test

include("binarysearch.jl")

function test_all()
    println("")

    test_binarysearch_all()
end

end
