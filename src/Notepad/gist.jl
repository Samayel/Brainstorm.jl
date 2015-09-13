
#=
https://github.com/JuliaLang/julia/issues/12557#issuecomment-129869903
=#

using JSON

function reload_gist(id)
    reload_content(cnt) = begin
        f = tempname() * ".jl"
        io = open(f, "w")
        print(io, cnt)
        close(io)
        include(f)
        rm(f)
    end

    gist = (open(download("https://api.github.com/gists/$id")) |> readlines |> join |> JSON.parse)

    for (k, v) in gist["files"]
        if ismatch(r"\.jl$", k) # This avoids read README.md
            reload_content(gist["files"][k]["content"])
        end
    end

    nothing
end
