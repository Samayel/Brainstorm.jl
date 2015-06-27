module Meta

using Brainstorm.Meta
using Base.Test

function test_all()
    println("")
    print(rpad("Meta...", 50, ' '))

    @test map(x -> isa(x, Int) ? x + 1 : x, :(1 + 1)) == :(2 + 2)

    println("PASS")
end

end
