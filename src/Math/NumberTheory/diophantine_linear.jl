export
    DiophantineEquationLinearXY,
    diophantine_equation_linear_xy


# Dx + Ey + F = 0
immutable DiophantineEquationLinearXY{T<:Integer}
    cx::T  # D
    cy::T  # E
    c0::T  # F
end

diophantine_equation_linear_xy{T<:Integer}(;cx::T=0, cy::T=0, c0::T=0) = DiophantineEquationLinearXY(cx, cy, c0)

Base.show(io::IO, eq::DiophantineEquationLinearXY) = print(io, "$(eq.cx)x + $(eq.cy)y + $(eq.c0) = 0")


solve{T<:Integer}(eq::DiophantineEquationLinearXY{T}) = begin
    cx, cy, c0 = eq.cx, eq.cy, eq.c0

    cx == cy == c0 == 0 && return diophantine_anyx_anyy(T)
    cx == cy == 0 && return diophantine_nonex_noney(T)

    cx == 0 && cy != 0 && return c0 % cy == 0 ?
        diophantine_anyx_oney(-div(c0, cy)) :
        diophantine_nonex_noney(T)

    cx != 0 && cy == 0 && return c0 % cx == 0 ?
        diophantine_onex_anyy(-div(c0, cx)) :
        diophantine_nonex_noney(T)

    g = gcd(cx, cy)
    c0 % g == 0 || return diophantine_nonex_noney(T)

    cx, cy, c0 = div(cx, g), div(cy, g), div(c0, g)
    _, u, v = gcdx(cx, cy)

    diophantine_linearx_lineary(cy, -c0*u, -cx, -c0*v)
end
