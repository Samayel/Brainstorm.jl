@reexport module Functor

import Base: call

#= Meta =#

immutable IsAFun{T} <: Base.Func{1} end
isa(t::Type) = IsAFun{t}()
call{T}(::IsAFun{T}, x) = Base.isa(x, T)


#= Collections =#

immutable GetIndexFun{T} <: Base.Func{1}
    idx::T
end
idx(i) = GetIndexFun(i)
call(f::GetIndexFun, a) = a[f.idx]


#= Comparison =#

immutable Leq1Fun{T} <: Base.Func{1}
    b::T
end
leq(b) = Leq1Fun(b)
call(f::Leq1Fun, a) = a <= f.b

immutable Geq1Fun{T} <: Base.Func{1}
    b::T
end
geq(b) = Geq1Fun(b)
call(f::Geq1Fun, a) = a >= f.b


#= Math =#

immutable TruncFun{T} <: Base.Func{1} end
trunc(t::Type) = TruncFun{t}()
call{T}(::TruncFun{T}, x) = Base.trunc(T, x)

immutable NegFun <: Base.Func{1} end
call(::NegFun, x) = -x

immutable InvFun <: Base.Func{1} end
call(::InvFun, x) = inv(x)

end
