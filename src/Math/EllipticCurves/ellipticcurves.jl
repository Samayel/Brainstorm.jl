@reexport module EllipticCurves

# http://jeremykun.com/2014/02/08/introducing-elliptic-curves/
# http://jeremykun.com/2014/02/24/elliptic-curves-as-python-objects/
# http://jeremykun.com/2014/03/19/connecting-elliptic-curves-with-finite-fields-a-reprise/

using Reexport.@reexport

export curve, point, samecurve, ideal, ring, field, isideal

import Base: +, -, *, show, rand, in
import Nemo: divexact, contains, order, gen

using AutoHashEquals
using Brainstorm.Math: factorization, factors
using Nemo
using Nemo: FinFieldElem

divexact(x::Number, y::Number) = x / y

include("curve.jl")
include("point.jl")
include("group.jl")

end
