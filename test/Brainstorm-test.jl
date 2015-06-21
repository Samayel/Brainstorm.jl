module Test

using Base.Test
using Lint.lintpkg

include("Algorithms/Algorithms-test.jl")
include("DataStructures/DataStructures-test.jl")
include("Math/Math-test.jl")
include("Meta/Meta-test.jl")

function test_internal()
    Algorithms.test_all()
    DataStructures.test_all()
    Math.test_all()
    Meta.test_all()
    println("")
    @test isempty(lintpkg("Brainstorm", returnMsgs=true))
end

function test_external()
    Pkg.test("AutoHashEquals")
    VERSION < v"0.4-" && Pkg.test("Combinatorics")
    # Pkg.test("ContinuedFractions")
    Pkg.test("DataStructures")
    # VERSION >= v"0.4-" && Pkg.test("DecFP")
    Pkg.test("Digits")
    Pkg.test("DualNumbers")
    Pkg.test("FastAnonymous")
    Pkg.test("FixedPointNumbers")
    VERSION < v"0.4-" && Pkg.test("Formatting")
    Pkg.test("FunctionalCollections")
    VERSION < v"0.4-" && Pkg.test("Graphs")
    Pkg.test("IntModN")
    VERSION < v"0.4-" && Pkg.test("IterationManagers")
    Pkg.test("Iterators")
    # Pkg.test("Lazy")
    Pkg.test("LightGraphs")
    Pkg.test("Lint")
    Pkg.test("Match")
    Pkg.test("MATLAB")
    # Pkg.test("Memoize")
    # Pkg.test("MinimalPerfectHashes")
    VERSION < v"0.4-" && Pkg.test("NamedTuples")
    Pkg.test("Pipe")
    Pkg.test("ProgressMeter")
    Pkg.test("Redis")
    Pkg.test("Reexport")
    Pkg.test("SortingAlgorithms")
    Pkg.test("SparseVectors")
    Pkg.test("ValidatedNumerics")
    # Pkg.test("ValueDispatch")
end

function test_all()
    test_internal()
    println("")
    test_external()
end

end
