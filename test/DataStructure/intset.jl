function test_intset_validated_setdiff()
    s = IntSet(1:9)

    @test validated_setdiff!(s, [1,3,5,7,9]) == true
    @test s == IntSet([2,4,6,8])

    @test validated_setdiff!(s, [11,13]) == false
    @test s == IntSet([2,4,6,8])

    @test validated_setdiff!(s, [2,4,6,10]) == false
    @test s == IntSet([2,4,6,8])

    @test validated_setdiff!(s, [2,4,6,8]) == true
    @test s == IntSet([])

    @test validated_setdiff!(s, [0]) == false
    @test s == IntSet([])

    @test validated_setdiff!(s, []) == true
    @test s == IntSet([])

    @test validated_setdiff!(IntSet(1:3), IntSet(2)) == true
end

function test_intset_all()
    print(rpad("DataStructure.IntSet...", 50, ' '))

    test_intset_validated_setdiff()

    println("PASS")
end
