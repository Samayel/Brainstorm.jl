
# https://groups.google.com/forum/#!msg/julia-users/Kh3SEBPwY1w/Xj2nxIitBwAJ

type Functor{Symbol} end

# A simple general product-sum operator;
# returns a[1]⊙b[1] ⊕ a[2]⊙b[2] ⊕ ...
@generated function dot{⊕,⊙,T}(::Type{Functor{⊕}}, ::Type{Functor{⊙}}, a::Array{T}, b::Array{T})
    return quote
        assert(length(a)==length(b))
        p = zero(T)
        for i=1:length(a)
            @inbounds p=$⊕(p,$⊙(a[i],b[i]))
        end
        p
    end
end



dot(Functor{:+},   Functor{:*}, [-1,0,1],[1,0,1])  # vector dot; returns 0
dot(Functor{:max}, Functor{:+}, [-1,0,1],[1,0,1])  # max-sum; returns 2
dot(Functor{:|},   Functor{:&}, [true,false,true],[false,true,true])  # constraint satisfaction; returns true
