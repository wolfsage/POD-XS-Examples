#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"


MODULE = Simple::Class		PACKAGE = Simple::Class

SV *
new(package, ...)
    SV *package
  PREINIT:
    HV *self;
    HV *stash;
    SV *self_ref;
    int i = 0;
  CODE:
    /* Make sure the first argument is a string */
    if (!SvPOK(package)) {
        croak("new() expects a package name");
    }

    /* Make sure we have an even number of arguments for our hash */
    if ((items-1) % 2) {
        croak("Odd number of elements in constructor arguments");
    }

    /* my %self; */
    self = newHV();

    /* Get our packages stash (needed for bless) */
    stash = gv_stashpv(SvPV_nolen(package), 0);
    if (!stash) {
        croak("Failed to find our stash!");
    }

    /* my $ref = \%self; # Weakened, though... */
    self_ref = newRV_noinc((SV*)self);

    /* Take @_ and fill in our object with it
     *
     *  ST(0) is the package name, ST(i) to ST(items-1) are the rest
     *  of the arguments */
    for (i = 1; i < items; i+= 2) {
        SV *obj = ST(i+1);

        /* if (ref $val) { # no refs allowed! } */
        if (SvROK(obj)) {
            croak("Hash value for '%s' must be a string", SvPV_nolen(ST(i)));
        }

        /* obj has refcount of 0 here I guess. It needs 1 which our
           hash will own */
        SvREFCNT_inc(obj);

        /* $self{$key} = $val */
        if (NULL == hv_store(self, SvPV_nolen(ST(i)), strlen(SvPV_nolen(ST(i))), obj, 0)) {
            croak("panic: hv_store() failed to store element in hash");
        }
    }

    /* return bless $self, __PACKAGE__ */
    RETVAL = sv_bless(self_ref, stash);
  OUTPUT:
    RETVAL


void
display(self)
    SV *self
  PREINIT:
    HV *obj;
    SV *next;
    char *key;
    I32 rlen;
  CODE:
    if (!sv_isobject(self)) {
         croak("Self is not an object");
    }

    obj = (HV*) SvRV(self);

    /* if (Scalar::Util::reftype($obj) ne 'HASH') { ... } */
    if (!(SvTYPE(obj) == SVt_PVHV)) {
        croak("Reference is not a hashref");
    }

    PerlIO_printf(PerlIO_stdout(), "Self:\n");

    /* Iterate through our hash and print out our keys/values.
     * 
     * Similar to:
     *
     *   while (my ($k, $v) = each %$self) {
     *       print "$k: $v\n";
     *   }
     */
    hv_iterinit(obj);

    while (next = hv_iternextsv(obj, &key, &rlen)) {
        PerlIO_printf(PerlIO_stdout(), "\t%s: %s\n", key, SvPV_nolen(next));
    }


