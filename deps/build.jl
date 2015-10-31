
try
    eval(Expr(:import,:Lists))
catch err
    Pkg.clone("https://github.com/Samayel/Lists.jl")
    Pkg.build("Lists")
end

try
    eval(Expr(:import,:Multicombinations))
catch err
    Pkg.clone("https://github.com/jlep/Multicombinations.jl")
    Pkg.build("Multicombinations")
end

try
    eval(Expr(:import,:Nemo))
catch err
    Pkg.clone("https://github.com/wbhart/Nemo.jl")
    Pkg.build("Nemo")
end
