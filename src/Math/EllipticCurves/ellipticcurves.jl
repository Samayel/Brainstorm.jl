@reexport module EllipticCurves

# http://jeremykun.com/2014/02/08/introducing-elliptic-curves/
# http://jeremykun.com/2014/02/24/elliptic-curves-as-python-objects/
# http://jeremykun.com/2014/03/19/connecting-elliptic-curves-with-finite-fields-a-reprise/

export curve, point, samecurve, ideal, ring, field

import Base: +, -, *, show
import Nemo: divexact, contains

using AutoHashEquals
using Nemo

divexact(x::Number, y::Number) = x / y

include("curve.jl")
include("point.jl")

end
