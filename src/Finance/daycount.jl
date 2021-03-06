
# https://en.wikipedia.org/wiki/Day_count_convention

export yearlength, daycount, yearfraction

export Thirty360Bond, Thirty360US, ThirtyE360, ThirtyE360ISDA
export Actual365Fixed, Actual364, Actual360
export ActualActualISDA



abstract type DayCountConvention end

abstract type FixedYear{N} <: DayCountConvention end
abstract type ActualYear <: DayCountConvention end


abstract type Thirty360 <: FixedYear{360} end

struct Thirty360Bond <: Thirty360 end
struct Thirty360US <: Thirty360
    eom::Bool
end
struct ThirtyE360 <: Thirty360 end
struct ThirtyE360ISDA <: Thirty360
    maturity::Date
end


abstract type ActualFixedYear{N} <: FixedYear{N} end

struct Actual365Fixed <: ActualFixedYear{365} end
struct Actual364 <: ActualFixedYear{364} end
struct Actual360 <: ActualFixedYear{360} end


abstract type ActualActual <: ActualYear end

struct ActualActualISDA <: ActualActual end



yearlength(::FixedYear{N}, year = 0) where {N} = N

yearlength(::ActualYear, year) = isleapyear(year) ? 366 : 365



daycount(::Union{ActualFixedYear, ActualActual}, a, b) = Dates.value(b - a)

daycount(c::Thirty360, a, b) = begin
    y1, m1 = yearmonth(a)
    y2, m2 = yearmonth(b)

    d1, d2 = adjustdays(c, a, b)

    360 * (y2 - y1) + 30 * (m2 - m1) + (d2 - d1)
end

adjustdays(::Thirty360Bond, a, b) = begin
    d1, d2 = day(a), day(b)

    d1 = min(d1, 30)
    d1 == 30 && (d2 = min(d2, 30))

    d1, d2
end

adjustdays(c::Thirty360US, a, b) = begin
    m1, d1 = monthday(a)
    m2, d2 = monthday(b)

    if c.eom && m1 == 2 && d1 == day(lastdayofmonth(a))
        m2 == 2 && d2 == day(lastdayofmonth(b)) && (d2 = 30)
        d1 = 30
    end

    d1 = min(d1, 30)
    d1 == 30 && (d2 = min(d2, 30))

    d1, d2
end

adjustdays(::ThirtyE360, a, b) = begin
    d1, d2 = day(a), day(b)

    d1 = min(d1, 30)
    d2 = min(d2, 30)

    d1, d2
end

adjustdays(c::ThirtyE360ISDA, a, b) = begin
    y1, m1, d1 = yearmonthday(a)
    y2, m2, d2 = yearmonthday(b)

    d1 == day(lastdayofmonth(a)) && (d1 = 30)
    d2 == day(lastdayofmonth(b)) && (m2 != 2 || b != c.maturity) && (d2 = 30)

    d1, d2
end



yearfraction(c::Union{Thirty360, ActualFixedYear}, a, b, s::Type{S} = Float64) where {S<:Real} = convert(S, daycount(c, a, b)) / yearlength(c)

yearfraction(c::ActualActualISDA, a, b, ::Type{S} = Float64) where {S<:Real} = begin
    firstyear = 1 - yearfraction(c, a)
    betweenyears = year(b) - year(a) - 1
    lastyear = yearfraction(c, b)

    convert(S, firstyear + betweenyears + lastyear)
end

yearfraction(c::ActualActualISDA, date, ::Type{S} = Float64) where {S<:Real} = (dayofyear(date) - 1) // yearlength(c, date)
