
try
    eval(Expr(:import,:DeepConvert))
catch err
    Pkg.clone("https://github.com/jlapeyre/DeepConvert.jl")
    Pkg.build("DeepConvert")
end

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
