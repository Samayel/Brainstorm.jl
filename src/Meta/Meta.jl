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

export @testtimed, includeall

macro testtimed(label, func, tests)
    quote
        local llabel = $(esc(label))
        print("$llabel... ")

        local lfunc = $(esc(func))
        precompile(lfunc, ())

        local lstats1 = @timed lfunc()
        local lstats2 = @timed lfunc()

        $(esc(tests))

        local lsolution = lstats1[1]
        local lduration1 = @sprintf("%11.6f", lstats1[2])
        local lduration2 = @sprintf("%11.6f", lstats2[2])
        println("PASS   [$(lduration1)s / $(lduration2)s]   $lsolution")
    end
end

function includeall(directory::String, skipFiles = true)
    for entry in readdir(directory)
        path = joinpath(directory, entry)

        isdir(path) && includeall(path, false)
        skipFiles && continue
        !isfile(path) && continue
        !Base.endswith(path, ".jl") && continue

        include(path)
    end
end

end
