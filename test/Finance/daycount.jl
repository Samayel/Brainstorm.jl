function daycount_testcases()
    dateranges = [
        Date(2014, 6, 4)  Date(2014, 6, 4)
        Date(2014, 8, 5)  Date(2016, 5, 25)
        Date(2015, 8, 5)  Date(2017, 5, 25)
        Date(2016, 8, 5)  Date(2018, 5, 25)
        Date(2016, 8, 29) Date(2018, 5, 31)
        Date(2016, 8, 30) Date(2018, 5, 31)
        Date(2016, 8, 31) Date(2018, 5, 31)
        Date(2014, 2, 28) Date(2016, 2, 28)
        Date(2014, 2, 28) Date(2016, 2, 29)
        Date(2015, 2, 27) Date(2017, 2, 28)
        Date(2015, 2, 28) Date(2017, 2, 28)
        Date(2014, 2, 28) Date(2016, 2, 28)
        Date(2014, 2, 28) Date(2016, 2, 29)
        Date(2015, 2, 27) Date(2017, 2, 28)
        Date(2015, 2, 28) Date(2017, 2, 28)
    ]

    daycount_Thirty360Bond  = [0, 650, 650, 650, 632, 630, 630, 720, 721, 721, 720, 720, 721, 721, 720]
    daycount_Thirty360US    = [0, 650, 650, 650, 632, 630, 630, 720, 721, 721, 720, 718, 720, 721, 720]
    daycount_ThirtyE360     = [0, 650, 650, 650, 631, 630, 630, 720, 721, 721, 720, 720, 721, 721, 720]
    daycount_ThirtyE360ISDA = [0, 650, 650, 650, 631, 630, 630, 718, 720, 723, 720, 718, 719, 721, 718]
    daycount_Actual         = [0, 659, 659, 658, 640, 639, 638, 730, 731, 732, 731, 730, 731, 732, 731]

    maturity = [Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date(2016, 3, 1), Date(2016, 3, 1), Date(2017, 3, 1), Date(2017, 3, 1), Date(2016, 2, 29), Date(2016, 2, 29), Date(2017, 2, 28), Date(2017, 2, 28)]
    eom = [false, false, false, false, false, false, false, false, false, false, false, true, true, true, true]

    dateranges, daycount_Thirty360Bond, daycount_Thirty360US, daycount_ThirtyE360, daycount_ThirtyE360ISDA, daycount_Actual, maturity, eom
end

function test_daycount_yearlength()
    test(daycounter, result) = begin
        @test [yearlength(daycounter, year) for year in [1900, 2000, 2015, 2016]] == result
    end

    test(Thirty360Bond(),        [360, 360, 360, 360])
    test(Thirty360US(false),     [360, 360, 360, 360])
    test(ThirtyE360(),           [360, 360, 360, 360])
    test(ThirtyE360ISDA(Date()), [360, 360, 360, 360])
    test(Actual365Fixed(),       [365, 365, 365, 365])
    test(Actual364(),            [364, 364, 364, 364])
    test(Actual360(),            [360, 360, 360, 360])
    test(ActualActualISDA(),     [365, 366, 365, 366])
end

function test_daycount_daycount()
    dateranges, daycount_Thirty360Bond, daycount_Thirty360US, daycount_ThirtyE360, daycount_ThirtyE360ISDA, daycount_Actual, maturity, eom = daycount_testcases()

    test(daycounter, result) = begin
        @test [daycount(daycounter(i), dateranges[i,:]...) for i in 1:size(dateranges, 1)] == result
    end

    test(i -> Thirty360Bond(),             daycount_Thirty360Bond)
    test(i -> Thirty360US(eom[i]),         daycount_Thirty360US)
    test(i -> ThirtyE360(),                daycount_ThirtyE360)
    test(i -> ThirtyE360ISDA(maturity[i]), daycount_ThirtyE360ISDA)
    test(i -> Actual365Fixed(),            daycount_Actual)
    test(i -> Actual364(),                 daycount_Actual)
    test(i -> Actual360(),                 daycount_Actual)
    test(i -> ActualActualISDA(),          daycount_Actual)
end

function test_daycount_yearfraction()
    dateranges, daycount_Thirty360Bond, daycount_Thirty360US, daycount_ThirtyE360, daycount_ThirtyE360ISDA, daycount_Actual, maturity, eom = daycount_testcases()

    test(daycounter, result) = begin
        @test [yearfraction(daycounter(i), dateranges[i,:]...) for i in 1:size(dateranges, 1)] == result
    end

    test(i -> Thirty360Bond(),             daycount_Thirty360Bond  ./ 360)
    test(i -> Thirty360US(eom[i]),         daycount_Thirty360US    ./ 360)
    test(i -> ThirtyE360(),                daycount_ThirtyE360     ./ 360)
    test(i -> ThirtyE360ISDA(maturity[i]), daycount_ThirtyE360ISDA ./ 360)
    test(i -> Actual365Fixed(),            daycount_Actual         ./ 365)
    test(i -> Actual364(),                 daycount_Actual         ./ 364)
    test(i -> Actual360(),                 daycount_Actual         ./ 360)
    test(i -> ActualActualISDA(), [
        0
        convert(Float64, (1 - 216 // 365) + 1 + 145 // 366)
        convert(Float64, (1 - 216 // 365) + 1 + 144 // 365)
        convert(Float64, (1 - 217 // 366) + 1 + 144 // 365)
        convert(Float64, (1 - 241 // 366) + 1 + 150 // 365)
        convert(Float64, (1 - 242 // 366) + 1 + 150 // 365)
        convert(Float64, (1 - 243 // 366) + 1 + 150 // 365)
        convert(Float64, (1 -  58 // 365) + 1 +  58 // 366)
        convert(Float64, (1 -  58 // 365) + 1 +  59 // 366)
        convert(Float64, (1 -  57 // 365) + 1 +  58 // 365)
        convert(Float64, (1 -  58 // 365) + 1 +  58 // 365)
        convert(Float64, (1 -  58 // 365) + 1 +  58 // 366)
        convert(Float64, (1 -  58 // 365) + 1 +  59 // 366)
        convert(Float64, (1 -  57 // 365) + 1 +  58 // 365)
        convert(Float64, (1 -  58 // 365) + 1 +  58 // 365)
    ])
end

function test_daycount_all()
    print(rpad("Finance.DayCount...", 50, ' '))

    test_daycount_yearlength()
    test_daycount_daycount()
    test_daycount_yearfraction()

    println("PASS")
end
