module Test

include("Algorithms/Algorithms-test.jl")
include("DataStructures/DataStructures-test.jl")
include("Math/Math-test.jl")
include("Meta/Meta-test.jl")

function test_internal()
  Algorithms.test_all()
  DataStructures.test_all()
  Math.test_all()
  Meta.test_all()
end

function test_external()
  VERSION < v"0.4-" && Pkg.test("Combinatorics")
  # Pkg.test("ContinuedFractions")
  Pkg.test("DataStructures")
  Pkg.test("Digits")
  Pkg.test("DualNumbers")
  Pkg.test("FastAnonymous")
  Pkg.test("FixedPointNumbers")
  Pkg.test("FunctionalCollections")
  VERSION < v"0.4-" && Pkg.test("Graphs")
  Pkg.test("IntModN")
  VERSION < v"0.4-" && Pkg.test("IterationManagers")
  Pkg.test("Iterators")
  # Pkg.test("Lazy")
  Pkg.test("LightGraphs")
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
