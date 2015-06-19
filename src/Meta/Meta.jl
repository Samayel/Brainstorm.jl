@reexport module Meta

using Reexport.@reexport

@reexport using Match
@reexport using Memoize
@reexport using Pipe
@reexport using ProgressMeter

# fix ambiguous definition
Base.map(f::Base.Callable, ex::Expr) =
    Expr(ex.head, [isa(e, Expr) ? map(f, e) : f(e) for e in ex.args]...)
@reexport using ValueDispatch

end
