@reexport module Functor


#= Meta =#

immutable IsA{T} <: Base.Func{1}
end
isa(t::Type) = IsA{t}()
Base.call{T}(::IsA{T}, x) = Base.isa(x, T)


#= Collections =#

immutable GetIndex{T} <: Base.Func{1}
    idx::T
end
idx(i) = GetIndex(i)
Base.call(f::GetIndex, a) = a[f.idx]


#= Comparison =#

immutable Leq1{T} <: Base.Func{1}
    b::T
end
leq(b) = Leq1(b)
Base.call(f::Leq1, a) = a <= f.b

immutable Geq1{T} <: Base.Func{1}
    b::T
end
geq(b) = geq1(b)
Base.call(f::Geq1, a) = a >= f.b


#= Math =#

immutable Trunc{T} <: Base.Func{1}
end
trunc(t::Type) = Trunc{t}()
Base.call{T}(::Trunc{T}, x) = Base.trunc(T, x)


end
