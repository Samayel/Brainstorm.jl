export
    PreAllocatedStack

mutable struct PreAllocatedStack{T<:Integer, S}
    top::T
    stack::Vector{S}
end

push!(s::PreAllocatedStack) = (s.top += 1; s)
pop!(s::PreAllocatedStack) = (s.top -= 1; s)
getindex(s::PreAllocatedStack, idx) = s.stack[s.top + idx]
