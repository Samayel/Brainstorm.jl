@reexport module Meta

using Pipe: @pipe
using Reexport: @reexport

export @pipe

@reexport using Memoize

export
    @testtimed,
    get_jl_filenames

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
        local lduration1 = @sprintf("%8.3f", lstats1[2])
        local lduration2 = @sprintf("%8.3f", lstats2[2])
        println("PASS   [$(lduration1)s / $(lduration2)s]   $lsolution")
    end
end

function get_jl_filenames(directory::AbstractString, skipRootFiles = false)
    files = AbstractString[]
    for entry in readdir(directory)
        path = joinpath(directory, entry)

        isdir(path) && push!(files, get_jl_filenames(path, false)...)
        skipRootFiles && continue
        !isfile(path) && continue
        !Base.endswith(path, ".jl") && continue

        push!(files, path)
    end
    files
end

end
