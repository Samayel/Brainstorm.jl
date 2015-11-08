
export Payment, CashFlow, npv, irr

immutable Payment{T, S<:Real}
    date::T
    amount::S
end

immutable CashFlow{T, S<:Real, R<:DayCountConvention}
    flow::Array{Payment{T,S},1}
    daycount::R
    basedate::Date
end



Base.length(cf::CashFlow) = length(cf.flows)

Base.convert{T<:Real}(::Type{Payment{T}}, p::Payment{Date}, daycount, base = today()) =
    Payment(yearfraction(daycount, base, p.date, T), p.amount)

Base.convert{T<:Real}(::Type{CashFlow{T}}, cf::CashFlow{Date}) =
    CashFlow([convert(Payment{T}, p, cf.daycount, cf.basedate) for p in cf.flow], cf.daycount, cf.basedate)

Base.show(io::IO, cf::CashFlow) = begin
    println(io, rpad("Day count convention:", 23, ' ') * "$(cf.daycount)")
    println(io, rpad("Base date:", 23, ' ') * "$(cf.basedate)")
    println(io, "Cash flow:")
    for p in cf.flow
        println(io, rpad("  $(p.date)", 23, ' ') * "$(p.amount)")
    end
end



npv(flow, rate) = sum([p.amount / (1 + rate)^p.date for p in flow])
npv{T<:Real}(cf::CashFlow{T}, rate::T) = npv(cf.flow, rate)
npv{T<:Real}(cf::CashFlow, rate::T) = npv(convert(CashFlow{T}, cf), rate)

irr(flow, r0) = fzero(NPVFun(flow), r0)
irr{T<:Real}(cf::CashFlow{T}, r0::T = 0.1) = irr(cf.flow, r0)
irr{T<:Real}(cf::CashFlow, r0::T = 0.1) = irr(convert(CashFlow{T}, cf), r0)


immutable NPVFun{T} <: Base.Func{1}
    flow::T
end
call(f::NPVFun, r) = npv(f.flow, r)
