module Machin

using Brainstorm.Math.Series.Arctan: arctansum

euler(digits::Integer)           = arctansum(digits, [2,   3], 4*[1,  1])
hermann(digits::Integer)         = arctansum(digits, [2,   7], 4*[2, -1])
hutton(digits::Integer)          = arctansum(digits, [3,   7], 4*[2,  1])
machin(digits::Integer)          = arctansum(digits, [5, 239], 4*[4, -1])

gauss(digits::Integer)           = arctansum(digits, [18,  57,  239], 4*[12,  8, -5])
strassnitzky(digits::Integer)    = arctansum(digits, [ 2,   5,    8], 4*[ 1,  1,  1])
klingenstierna(digits::Integer)  = arctansum(digits, [10, 239,  515], 4*[ 8, -1, -4])
euler3(digits::Integer)          = arctansum(digits, [ 5,  70,   99], 4*[ 4, -1,  1])
loney(digits::Integer)           = arctansum(digits, [ 4,  20, 1985], 4*[ 3,  1,  1])
stoermer(digits::Integer)        = arctansum(digits, [ 8,  57,  239], 4*[ 6,  2,  1])

takano1982(digits::Integer)      = arctansum(digits, Int64[49, 57, 239, 110443], 4*[12, 32,  -5, 12])
stoermer1896(digits::Integer)    = arctansum(digits, Int64[57, 239, 682, 12943], 4*[44,  7, -12, 24])

hwang1997(digits::Integer)       = arctansum(digits, Int64[239, 1023, 5832, 110443, 4841182, 6826318], 4*[183, 32, -68, 12, -12, -100])
hwang2003(digits::Integer)       = arctansum(digits, BigInt[239, 1023, 5832, 113021, 6826318, 33366019650, 43599522992503626068], 4*[183, 32, -68, 12, -100, -12, 12])
wetherfield2004(digits::Integer) = arctansum(digits, BigInt[107, 1710, 103697, 2513489, 18280007883, 7939642926390344818, 3054211727257704725384731479018], 4*[83, 17, -22, -24, -44, 12, 22])

end
