module Algebra

using Base.Test
using Brainstorm

include("group.jl")
include("field.jl")

function test_all()
    test_group_all()
    test_field_all()
end

end
