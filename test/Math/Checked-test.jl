function test_checked_checkedadd()
  @test_throws OverflowError checkedadd(typemin(Int), -1)
  @test checkedadd(typemin(Int), 0) == typemin(Int)
  @test checkedadd(typemin(Int), 1) == typemin(Int) + 1
  @test checkedadd(typemax(Int), -1) == typemax(Int) - 1
  @test checkedadd(typemax(Int), 0) == typemax(Int)
  @test_throws OverflowError checkedadd(typemax(Int), 1)
end

function test_checked_all()
  print("Math.Checked...")

  test_checked_checkedadd()

  println("PASS")
end
