
const ARB_CALC_SUCCESS = 0
const ARB_CALC_IMPRECISE_INPUT = 1
const ARB_CALC_NO_CONVERGENCE = 2

const BLOCK_NO_ZERO = 0
const BLOCK_ISOLATED_ZERO = 1
const BLOCK_UNKNOWN = 2

################################################################################
#
#  https://github.com/fredrik-johansson/arb/blob/master/arb_calc/refine_root_bisect.c
#
################################################################################

_arb_sign(t::arb_t) = begin
    arb_is_positive(t) && return 1
    ifelse(arb_is_negative(t), -1, 0)
end

_arf_interval_signs(func, t::arf_interval_t, arb::ArbField) = begin
    x = arb()

    arb_set_arf(x, t.a)
    y = func(x, 1)[1]
    asign = _arb_sign(y)

    arb_set_arf(x, t.b)
    y = func(x, 1)[1]
    bsign = _arb_sign(y)

    asign, bsign
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

arb_calc_refine_root_bisect(func, start::arf_interval_t, iter, arb::ArbField) = begin
    r = arf_interval_t()

    # must have proper sign changes
    asign, bsign = _arf_interval_signs(func, start, arb)
    (asign == 0 || bsign == 0 || asign == bsign) && return ARB_CALC_IMPRECISE_INPUT, r

    arf_interval_set(r, start)
    t, u = arf_interval(), arf_interval()

    for i in 1:iter
        msign = arb_calc_partition(t, u, func, r, arb)

        # the algorithm fails if the value at the midpoint cannot be distinguished from zero
        msign == 0 && return ARB_CALC_NO_CONVERGENCE, r

        arf_interval_swap(r, ifelse(msign == asign, u, t))
    end

    ARB_CALC_SUCCESS, r
end

arb_calc_refine_root_bisect{T}(func, start::T, iter, arb::ArbField) = begin
    interval = convert(arf_interval_t, start)
    s, r = arb_calc_refine_root_bisect(func, interval, iter, arb)
    s, convert(T, r)
end

################################################################################
#
#  https://github.com/fredrik-johansson/arb/blob/master/arb_calc/isolate_roots.c
#
################################################################################

check_block(func, block::arf_interval_t, asign, bsign, arb::ArbField) = begin
    x = arb()
    arf_interval_get_arb(x, block, prec(arb))

    t = func(x, 1)[1]

    !arb_is_positive(t) || return BLOCK_NO_ZERO
    !arb_is_negative(t) || return BLOCK_NO_ZERO
    asign < 0 < bsign || asign > 0 > bsign || return BLOCK_UNKNOWN

    t = func(x, 2)[2]

    arb_is_finite(t) || return BLOCK_UNKNOWN
    !arb_contains_zero(t) || return BLOCK_UNKNOWN

    BLOCK_ISOLATED_ZERO
end

isolate_roots_recursive(blocks::arf_interval_ptr, flags::Vector{Int}, func, block::arf_interval_t, asign, bsign, depth, eval_count, found_count, arb::ArbField, verbose) = begin

    add_block(block::arf_interval_t, status) = begin
        b = arf_interval()
        arf_interval_set(b, block)
        push!(blocks, b)
        push!(flags, status)
    end

    if eval_count <= 0 || found_count <= 0
        add_block(block, BLOCK_UNKNOWN)
        return eval_count, found_count
    end

    eval_count -= 1
    status = check_block(func, block, asign, bsign, arb)

    status != BLOCK_NO_ZERO || return eval_count, found_count

    if status == BLOCK_ISOLATED_ZERO || depth <= 0
        if status == BLOCK_ISOLATED_ZERO
            if verbose
                print("found isolated root in: ")
                arf_interval_printd(block, 15)
                println()
            end
            found_count -= 1
        end

        add_block(block, status)
    else
        L, R = arf_interval(), arf_interval()
        msign = arb_calc_partition(L, R, func, block, arb)

        if msign == 0 && verbose
            print("possible zero at midpoint: ")
            arf_interval_printd(block, 15)
            println()
        end

        eval_count, found_count = isolate_roots_recursive(blocks, flags, func, L, asign, msign, depth - 1, eval_count, found_count, arb, verbose)
        eval_count, found_count = isolate_roots_recursive(blocks, flags, func, R, msign, bsign, depth - 1, eval_count, found_count, arb, verbose)
    end

    eval_count, found_count
end

arb_calc_isolate_roots(func, block::arf_interval_t, maxdepth, maxeval, maxfound, arb::ArbField, verbose = false) = begin
    blocks = arf_interval_ptr()
    flags = Vector{Int}()
    
    asign, bsign = _arf_interval_signs(func, block, arb)

    isolate_roots_recursive(blocks, flags, func, block, asign, bsign, maxdepth, maxeval, maxfound, arb, verbose)

    blocks, flags
end

arb_calc_isolate_roots{T}(func, block::T, maxdepth, maxeval, maxfound, arb::ArbField, verbose = false) = begin
    interval = convert(arf_interval_t, block)
    blocks, flags = arb_calc_isolate_roots(func, interval, maxdepth, maxeval, maxfound, arb, verbose)
    [convert(T, b) for b in blocks], flags
end
