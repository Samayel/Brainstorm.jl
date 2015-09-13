
#=
https://groups.google.com/d/msg/julia-users/1bwx3fjSO5A/V_inIa7eCAAJ
=#

using MacroTools, Lazy

import MacroTools: prewalk

function prockey(key)
    @capture(key, (a_:b_) | (a_=>b_)) || error("Invalid json key $key")
    isa(a, Symbol) && (a = Expr(:quote, a))
    :($a=>$b)
end

function procmap(d)
    @capture(d, {xs__}) || return d
    :(Dict($(map(prockey, xs)...)))
end

macro json(ex)
    @>> ex prewalk(procmap) esc
end


data = @json {
    displayrows: 20,
    cols: [
        { col: "l1" },
        { col: "l2" },
        { col: "l3" },
        { col: "num", display: true },
        { col: "sum", display: true, conf: { style: 1, func: { method: "sum", col: "num"  } } }
    ]
}
