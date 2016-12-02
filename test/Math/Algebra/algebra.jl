module Algebra

using Base.Test
using Brainstorm
using Nemo

include("group.jl")
include("field.jl")

function test_all()
    test_group_all()
    test_field_all()
end

end
