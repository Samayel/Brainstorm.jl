using Cxx

addHeaderDir("/usr/local/include", kind=C_System)
addHeaderDir("/usr/local/include/flint", kind=C_System)
Libdl.dlopen("/usr/local/lib/libgmp.so", Libdl.RTLD_GLOBAL)
Libdl.dlopen("/usr/local/lib/libmpfr.so", Libdl.RTLD_GLOBAL)
Libdl.dlopen("/usr/local/lib/libflint.so", Libdl.RTLD_GLOBAL)
Libdl.dlopen("/usr/local/lib/libarb.so", Libdl.RTLD_GLOBAL)

cxx""" #include "arb.h" """
cxx"""
void c_function(int digits)
{
    arb_t x;
    arb_init(x);
    arb_const_pi(x, digits * 3.33);
    arb_printn(x, digits, 0); printf("\n");
    printf("Computed with arb-%s\n", arb_version);
    arb_clear(x);
}
"""
julia_function() = @cxx c_function(100)
julia_function()
