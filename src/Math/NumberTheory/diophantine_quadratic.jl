export
    DiophantineEquationQuadraticXY,
    diophantine_equation_quadratic_xy


# Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0
immutable DiophantineEquationQuadraticXY{T<:Integer}
    cx²::T # A
    cxy::T # B
    cy²::T # C
    cx::T  # D
    cy::T  # E
    c0::T  # F
end

diophantine_equation_quadratic_xy{T<:Integer}(;cx²::T=0, cxy::T=0, cy²::T=0, cx::T=0, cy::T=0, c0::T=0) = DiophantineEquationQuadraticXY(cx², cxy, cy², cx, cy, c0)

Base.show(io::IO, eq::DiophantineEquationQuadraticXY) = print(io, "$(eq.cx²)x² + $(eq.cxy)xy + $(eq.cy²)y² + $(eq.cx)x + $(eq.cy)y + $(eq.c0) = 0")

evaluate{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}, sol::DiophantineSolutionXY{T}) = evaluate(eq, sol.x, sol.y)
evaluate{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}, x::T, y::T) = eq.cx² * x^2 + eq.cxy * x * y + eq.cy² * y^2 + eq.cx * x + eq.cy * y + eq.c0


solve{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}) = begin
    cx², cxy, cy², cx, cy, c0 = eq.cx², eq.cxy, eq.cy², eq.cx, eq.cy, eq.c0

    cx² == cxy == cy² == 0 && return AbstractDiophantineSolutions{DiophantineSolutionXY{T}}[solve(diophantine_equation_linear_xy(cx=cx, cy=cy, c0=c0))]
    cx² == cy² == 0 && return solve_simplehyperbolic(eq)

    discriminant = cxy^2 - 4*cx²*cy²
    discriminant < 0 && return solve_elliptical(eq)
    discriminant == 0 && return solve_parabolic(eq)
    solve_hyperbolic(eq)
end

solve_simplehyperbolic{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}) = begin
    cxy, cx, cy, c0 = eq.cxy, eq.cx, eq.cy, eq.c0

    solutions = AbstractDiophantineSolutions{DiophantineSolutionXY{T}}[]

    d = cx * cy - cxy * c0
    if d == 0
        cy % cxy == 0 && push!(solutions, diophantine_onex_anyy(-div(cy, cxy)))
        cx % cxy == 0 && push!(solutions, diophantine_anyx_oney(-div(cx, cxy)))
    else
        xytuples = Tuple{T,T}[]
        for f in factors(abs(d); negative = true)
            x, r = divrem(f - cy, cxy)
            r == 0 || continue
            y, r = divrem(div(d, f) - cx, cxy)
            r == 0 || continue
            push!(xytuples, (x, y))
        end
        push!(solutions, isempty(xytuples) ? diophantine_nonex_noney(T) : diophantine_solutions(xytuples))
    end

    solutions
end

solve_elliptical{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}) = begin
    cx², cxy, cy², cx, cy, c0 = eq.cx², eq.cxy, eq.cy², eq.cx, eq.cy, eq.c0

    f(t) = (cxy^2 - 4*cx²*cy²)*t^2 + 2(cxy*cy - 2*cy²*cx)*t + (cy^2 - 4*cy²*c0)
    z = map(Functor.trunc(Integer), fzeros(f))

    isempty(z) && return AbstractDiophantineSolutions{DiophantineSolutionXY{T}}[diophantine_nonex_noney(T)]

    xytuples = Tuple{T,T}[]

    sort!(z)
    for x = z[1]:z[2]
        u = f(x)
        v = isqrt(u)
        v*v == u || continue

        y, r = divrem(-(cxy*x + cy) + v, 2*cy²)
        r == 0 && push!(xytuples, (x, y))

        v != 0 || continue
        y, r = divrem(-(cxy*x + cy) - v, 2*cy²)
        r == 0 && push!(xytuples, (x, y))
    end

    solution = isempty(xytuples) ? diophantine_nonex_noney(T) : diophantine_solutions(xytuples)
    AbstractDiophantineSolutions{DiophantineSolutionXY{T}}[solution]
end

solve_parabolic{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}) = begin
    cx², cxy, cy², cx, cy, c0 = eq.cx², eq.cxy, eq.cy², eq.cx, eq.cy, eq.c0

    solutions = AbstractDiophantineSolutions{DiophantineSolutionXY{T}}[]

    g = copysign(gcd(cx², cy²), cx²)
    a, b, c = div(cx², g), div(cxy, g), div(cy², g)
    ra, rc = isqrt(a), copysign(isqrt(c), b)

    f(t) = ra * g * t^2 + cx * t + ra * c0

    d = rc * cx - ra * cy
    if d == 0
        u = map(Functor.trunc(Integer), fzeros(f))

        isempty(u) && push!(solutions, diophantine_nonex_noney(T))
        for v in u
            f(v) == 0 && push!(solutions, solve(diophantine_equation_linear_xy(cx=ra, cy=rc, c0=-v)))
        end
    else
        for u = 0:(abs(d) - 1)
            f(u) % d == 0 || continue
            push!(solutions, diophantine_quadraticx_quadraticy(
                rc * g * (-d), -(cy + 2 * rc * g * u), -div(rc * g * u^2 + cy * u + rc * c0, d),
                ra * g *   d,    cx + 2 * ra * g * u,   div(ra * g * u^2 + cx * u + ra * c0, d)
            ))
        end
    end

    solutions
end

solve_hyperbolic{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}) = begin
    (eq.cx == eq.cy == 0) ?
        solve_hyperbolic_homogeneous(eq) :
        solve_hyperbolic_general_quadratic(eq)
end

solve_hyperbolic_homogeneous{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}) = begin
    cx², cxy, cy², c0 = eq.cx², eq.cxy, eq.cy², eq.c0

    solutions = AbstractDiophantineSolutions{DiophantineSolutionXY{T}}[]

    discriminant = cxy^2 - 4*cx²*cy²
    k = isqrt(discriminant)

    if c0 == 0
        push!(solutions, diophantine_solutions((0, 0)))
        if k*k == discriminant
            push!(solutions, solve(diophantine_equation_linear_xy(cx=2*cx², cy=cxy+k, c0=0)))
            push!(solutions, solve(diophantine_equation_linear_xy(cx=2*cx², cy=cxy-k, c0=0)))
        end
        return solutions
    end

    if k*k == discriminant
        xytuples = Tuple{T,T}[]
        for f in factors(abs(-4*cx²*c0); negative = true)
            y, r = divrem(f + div(4*cx²*c0, f), 2*k)
            r == 0 || continue
            x, r = divrem(f - (cxy + k)*y, 2*cx²)
            r == 0 || continue
            push!(xytuples, (x, y))
        end
        push!(solutions, isempty(xytuples) ? diophantine_nonex_noney(T) : diophantine_solutions(xytuples))
        return solutions
    end

    # WIP
end
