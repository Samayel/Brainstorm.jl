module _Algorithm

using Brainstorm._Algorithm
using Base.Test

include("binarysearch.jl")

function test_all()
    println("")

    test_binarysearch_all()
end

end
