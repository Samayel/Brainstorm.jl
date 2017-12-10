
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


file = joinpath(Pkg.dir("Nemo"), "src", "flint", "fmpq_rel_series.jl")
content = readstring(file)
content = replace(content, "fmpq_poly_scalar_divexact_", "fmpq_poly_scalar_div_")
open(file, "w") do f
    write(f, content)
end
