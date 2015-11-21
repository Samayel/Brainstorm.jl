module Machin

using Brainstorm.Math.Series.Arctan: arctanhsum

# http://numbers.computation.free.fr/Constants/Log2/log2.html
ln2(digits::Integer) = arctanhsum(digits, [26, 4801, 8749], [18, -2, 8])

end
