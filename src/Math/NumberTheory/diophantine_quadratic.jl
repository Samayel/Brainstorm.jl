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
