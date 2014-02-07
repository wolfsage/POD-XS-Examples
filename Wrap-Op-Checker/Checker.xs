#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

/* The ckfunc we're replacing */
static Perl_check_t old_checker;

/* Our replacement function. This will modify an OP_CONST
 * if it matches a certain string. Note that this is only
 * called when the OP_CONST is compiled, not when it is
 * executed.
 */

static OP *my_check(pTHX_ OP *op) {
    SV *sv = cSVOPx_sv(op);

    if (sv) {
        SV *cmp = sv_2mortal(newSVpvs("Hello world"));

        if (sv_eq(sv, cmp)) {
            SvREADONLY_off(sv);
            sv_setpv(sv, "Hello Perl");
            SvREADONLY_on(sv);
        }
    }

    /* Let the previous ckfunc do its work */
    return old_checker(op);
}     

MODULE = Wrap::Op::Checker		PACKAGE = Wrap::Op::Checker		

BOOT:
    wrap_op_checker(OP_CONST, my_check, &old_checker);
