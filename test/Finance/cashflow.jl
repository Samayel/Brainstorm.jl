function test_cashflow_irr()
    daycount = ActualActualISDA()
    evaluationdate = Date(2014, 6, 4)
    payments = [
        Payment(evaluationdate, -996.90)
        Payment(Date(2014, 12, 29), 531.5)
        Payment(Date(2015, 12, 29), 15.75)
        Payment(Date(2016, 12, 29), 15.75)
        Payment(Date(2017, 12, 29), 15.75)
        Payment(Date(2017, 12, 29), 500.0)
    ]
    cf = CashFlow(payments, daycount, evaluationdate)
    @test_approx_eq irr(cf) 0.040142375624945

    daycount = ActualActualISDA()
    evaluationdate = Date(2014, 12, 5)
    payments = [
        Payment(evaluationdate, -1007.572602739726)
        Payment(Date(2015, 12, 3), 31.5)
        Payment(Date(2016, 12, 3), 31.5)
        Payment(Date(2017, 12, 4), 31.5)
        Payment(Date(2018, 12, 3), 31.5)
        Payment(Date(2018, 12, 3), 1000.0)
    ]
    cf = CashFlow(payments, daycount, evaluationdate)
    @test_approx_eq irr(cf) 0.029507633486583
end

function test_cashflow_all()
    print(rpad("Finance.CashFlow...", 50, ' '))

    test_cashflow_irr()

    println("PASS")
end
