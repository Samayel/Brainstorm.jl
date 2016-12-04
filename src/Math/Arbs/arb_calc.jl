
const ARB_CALC_SUCCESS = 0
const ARB_CALC_IMPRECISE_INPUT = 1
const ARB_CALC_NO_CONVERGENCE = 2

_arb_sign(t::arb_t) = begin
    arb_is_positive(t) && return 1
    ifelse(arb_is_negative(t), -1, 0)
end

arb_calc_partition(L::arf_interval_t, R::arf_interval_t, func, block::arf_interval_t, arb::ArbField) = begin
    # Compute the midpoint (TODO: try other points)
    u = arf()
    arf_add(u, block.a, block.b, ARF_PREC_EXACT, ARF_RND_DOWN)
    arf_mul_2exp_si(u, u, -1)

    # Evaluate and get sign at midpoint
    m = arb()
    arb_set_arf(m, u)
    t = func(m, 1)[1]
    msign = _arb_sign(t)

    # L, R = block, split at midpoint
    arf_set(L.a, block.a)
    arf_set(R.b, block.b)
    arf_set(L.b, u)
    arf_set(R.a, u)

    msign
end

arb_calc_refine_root_bisect(r::arf_interval_t, func, start::arf_interval_t, iter, arb::ArbField) = begin
    m = arb()

    arb_set_arf(m, start.a)
    v = func(m, 1)[1]
    asign = _arb_sign(v)

    arb_set_arf(m, start.b)
    v = func(m, 1)[1]
    bsign = _arb_sign(v)

    # must have proper sign changes
    (asign == 0 || bsign == 0 || asign == bsign) && return ARB_CALC_IMPRECISE_INPUT

    arf_interval_set(r, start)
    t, u = arf_interval(), arf_interval()

    for i in 1:iter
        msign = arb_calc_partition(t, u, func, r, arb)

        # the algorithm fails if the value at the midpoint cannot be distinguished from zero
        (msign == 0) && return ARB_CALC_NO_CONVERGENCE

        arf_interval_swap(r, ifelse(msign == asign, u, t))
    end

    ARB_CALC_SUCCESS
end
