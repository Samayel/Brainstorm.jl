export
    DiophantineEquationQuadraticXY


# Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0
immutable DiophantineEquationQuadraticXY{T<:Integer}
    cx²::T # A
    cxy::T # B
    cy²::T # C
    cx::T  # D
    cy::T  # E
    c0::T  # F
end

Base.show(io::IO, eq::DiophantineEquationQuadraticXY) = print(io, "$(eq.cx²)x² + $(eq.cxy)xy + $(eq.cy²)y² + $(eq.cx)x + $(eq.cy)y + $(eq.c0) = 0")


solve{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}) = begin
    cx², cxy, cy², cx, cy, c0 = eq.cx², eq.cxy, eq.cy², eq.cx, eq.cy, eq.c0

    cx² == cxy == cy² == 0 && return AbstractDiophantineSolutions{DiophantineSolutionXY{T}}[solve(DiophantineEquationLinearXY(cx, cy, c0))]
    cx² == cy² == 0 && return solve_simplehyperbolic(eq)

    discriminant = cxy^2 - 4*cx²*cy²
    discriminant < 0 && return solve_elliptical(eq)
    discriminant == 0 && return solve_parabolic(eq)
    solve_hyperbolic(eq)
end

solve_simplehyperbolic{T<:Integer}(eq::DiophantineEquationQuadraticXY{T}) = begin
    cxy, cx, cy, c0 = eq.cxy, eq.cx, eq.cy, eq.c0

    solutions = AbstractDiophantineSolutions{DiophantineSolutionXY{T}}[]

    discriminant = cx * cy - cxy * c0
    if discriminant == 0
        cy % cxy == 0 && push!(solutions, diophantine_onex_anyy(-div(cy, cxy)))
        cx % cxy == 0 && push!(solutions, diophantine_anyx_oney(-div(cx, cxy)))
    else
        @compat xytuples = Tuple{T,T}[]
        divisors = flatten([[f,-f] for f in factors(discriminant)])
        for d in divisors
            x, r = divrem(d - cy, cxy)
            r == 0 || continue
            y, r = divrem(div(discriminant, d) - cx, cxy)
            r == 0 || continue
            push!(xytuples, (x, y))
        end
        push!(solutions, isempty(xytuples) ? diophantine_nonex_noney(T) : diophantine_solutions(xytuples))
    end

    solutions
end
