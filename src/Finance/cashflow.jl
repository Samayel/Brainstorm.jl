
export Payment, CashFlow, npv, irr

struct Payment{T, S<:Real}
    date::T
    amount::S
end

struct CashFlow{T, S<:Real, R<:DayCountConvention}
    flow::Array{Payment{T,S},1}
    daycount::R
    basedate::Date
end



Base.length(cf::CashFlow) = length(cf.flows)

Base.convert(::Type{Payment{T}}, p::Payment{Date}, daycount, base = today()) where {T<:Real} =
    Payment(yearfraction(daycount, base, p.date, T), p.amount)

Base.convert(::Type{CashFlow{T}}, cf::CashFlow{Date}) where {T<:Real} =
    CashFlow([convert(Payment{T}, p, cf.daycount, cf.basedate) for p in cf.flow], cf.daycount, cf.basedate)

Base.show(io::IO, cf::CashFlow) = begin
    println(io, rpad("Day count convention:", 23, ' ') * "$(cf.daycount)")
    println(io, rpad("Base date:", 23, ' ') * "$(cf.basedate)")
    println(io, "Cash flow:")
    for p in cf.flow
        println(io, rpad("  $(p.date)", 23, ' ') * "$(p.amount)")
    end
end



npv(flow, rate) = sum(p.amount / (1 + rate)^p.date for p in flow)
npv(cf::CashFlow{T}, rate::T) where {T<:Real} = npv(cf.flow, rate)
npv(cf::CashFlow, rate::T) where {T<:Real} = npv(convert(CashFlow{T}, cf), rate)

irr(flow, r0) = fzero(r -> npv(flow, r), r0)
irr(cf::CashFlow{T}, r0::T = 0.1) where {T<:Real} = irr(cf.flow, r0)
irr(cf::CashFlow, r0::T = 0.1) where {T<:Real} = irr(convert(CashFlow{T}, cf), r0)
