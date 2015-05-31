importall ValidatedNumerics

export
  Interval,
  @interval, @biginterval, @floatinterval, @make_interval,
  get_interval_rounding, set_interval_rounding,
  diam, mid, mag, mig, hull, isinside,
  emptyinterval, ∅, isempty, ⊊,
  widen,
  set_interval_precision, get_interval_precision,
  interval_parameters, eps, dist, roughly,
  get_pi

## Root finding
export
  newton, krawczyk,
  differentiate, D, # should these be exported?
  Root,
  find_roots
