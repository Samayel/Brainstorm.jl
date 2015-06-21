
try
    eval(Expr(:import,:DeepConvert))
catch err
    Pkg.clone("https://github.com/jlapeyre/DeepConvert.jl.git")
    Pkg.build("DeepConvert")
end
