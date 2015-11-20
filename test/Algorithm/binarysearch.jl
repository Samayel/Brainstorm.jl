function test_binarysearch_all()
    print(rpad("Algorithm.BinarySearch...", 50, ' '))

    @test [binarysearch(x -> x, i, 1, 100) for i in 1:100] == [(i,i) for i in 1:100]
    @test [binarysearch(x -> 2x, i, 0, 10) for i in 2:10] == [(1,1); (1,2); (2,2); (2,3); (3,3); (3,4); (4,4); (4,5); (5,5)]

    @test_throws DomainError binarysearch(x -> x, 0, 1, 10)
    @test_throws DomainError binarysearch(x -> x, 11, 1, 10)

    println("PASS")
end
