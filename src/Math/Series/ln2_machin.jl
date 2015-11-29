module Machin

using Brainstorm.Math.Series.Arctan: arctanhsum

# http://numbers.computation.free.fr/Constants/Log2/log2.html
ln2_N2a(digits::Integer) = arctanhsum(digits, [5,  7], [2, 2])
ln2_N2b(digits::Integer) = arctanhsum(digits, [6, 99], [4, 2])
ln2_N2c(digits::Integer) = arctanhsum(digits, [7, 17], [4, 2])

ln2_N3a(digits::Integer) = arctanhsum(digits, [11,  111, 19601], [ 8, -4, -2])
ln2_N3b(digits::Integer) = arctanhsum(digits, [17,   79,  1351], [10,  8,  4])
ln2_N3c(digits::Integer) = arctanhsum(digits, [23,   65,   485], [14,  6, -4])
ln2_N3d(digits::Integer) = arctanhsum(digits, [26, 4801,  8749], [18, -2,  8])
ln2_N3e(digits::Integer) = arctanhsum(digits, [31,   49,   161], [14, 10,  6])

ln2_N4a(digits::Integer) = arctanhsum(digits, Int64[ 52, 4801, 8749, 70226], [ 36, -2,   8,  18])
ln2_N4b(digits::Integer) = arctanhsum(digits,      [127,  449, 4801,  8749], [ 72, 54,  34, -10])
ln2_N4c(digits::Integer) = arctanhsum(digits,      [251,  449, 4801,  8749], [144, 54, -38,  62])

ln2_N5a(digits::Integer) = arctanhsum(digits, Int64[575, 3361, 8749, 13121, 56251], [342, 198, 222, 160, 106])

end
