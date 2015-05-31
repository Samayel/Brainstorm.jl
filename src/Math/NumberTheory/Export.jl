# *** Combinatorics.jl ***

if VERSION < v"0.4-"
  export bell,
  export catalan,
  export derangement,
  export doublefactorial,
  export fibonacci,
  export hyperfactorial,
  export jacobisymbol,
  export lassalle,
  export legendresymbol,
  export lucas,
  export multifactorial,
  export multinomial,
  export primorial,
  export stirlings1,
  export subfactorial

  export cool_lex, integer_partitions, ncpartitions
end

# *** Primes.jl ***

export fastprimes

export mfactor
export genprimes, countprimes, primepi
export nextprime, prevprime
export nprimes, nthprime
export allprimes, someprimes

export divisorsigma
export factorsort, invfactor
export least_number_with_d_divisors

# *** Fibonacci.jl ***

export nthfibonacci, nfibonacci
export allfibonacci, somefibonacci, exactfibonacci
