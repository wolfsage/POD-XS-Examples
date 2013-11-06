#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

/* Taken from XS::Object::Magic */

STATIC MGVTBL null_mg_vtbl = {
    NULL, /* get */
    NULL, /* set */
    NULL, /* len */
    NULL, /* clear */
    NULL, /* free */
#if MGf_COPY
    NULL, /* copy */
#endif /* MGf_COPY */
#if MGf_DUP
    NULL, /* dup */
#endif /* MGf_DUP */
#if MGf_LOCAL
    NULL, /* local */
#endif /* MGf_LOCAL */
};

typedef struct {
	SV *name;
	SV *data;
} private_sv_data;

MODULE = Simple::Class::Private::Data::Any		PACKAGE = Simple::Class::Private::Data::Any

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

        /* Storing '_private' string? Hide it from Perl land in magic */
        if (!strcmp(SvPV_nolen(ST(i)), "_private")) {
            private_sv_data *pdata;
            Newx(pdata, sizeof(pdata), private_sv_data);

            pdata->name = SvREFCNT_inc(ST(i));
            pdata->data = SvREFCNT_inc(sv_mortalcopy(obj));

            /* Make us magic! */
            sv_magicext((SV*)self, NULL, PERL_MAGIC_ext, &null_mg_vtbl, pdata, 0);

        } else {
            /* if (ref $val) { # no refs allowed! } */
            if (SvROK(obj)) {
                croak("Hash value for '%s' must be a string", SvPV_nolen(ST(i)));
            }

            /* $self{$key} = $val */

            /* obj has refcount of 0 here I guess. It needs 1 which our
               hash will own */
            SvREFCNT_inc(obj);

            if (NULL == hv_store(self, SvPV_nolen(ST(i)), strlen(SvPV_nolen(ST(i))), obj, 0)) {
                croak("panic: hv_store() failed to store element in hash");
            }
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

    /* Any private data? */
    if (SvTYPE(obj) >= SVt_PVMG) {
        MAGIC *mg;

        /* Our object may have lots of magic, look through it all to
           find ours */
        for (mg = SvMAGIC(obj); mg; mg = mg->mg_moremagic) {
            if (
                    (mg->mg_type == PERL_MAGIC_ext)
                 && (mg->mg_virtual == &null_mg_vtbl)
            ) {
                private_sv_data *pdata = (private_sv_data*)mg->mg_ptr;

                PerlIO_printf(PerlIO_stdout(), "\t%s: %s\n",
                    SvPV_nolen(pdata->name),
                    SvPV_nolen(pdata->data)
                );
            }
        }
    }


void
DESTROY(self)
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

    /* Any private data? */
    if (SvTYPE(obj) >= SVt_PVMG) {
        MAGIC *mg;

        /* Our object may have lots of magic, look through it all to
           find ours */
        for (mg = SvMAGIC(obj); mg; mg = mg->mg_moremagic) {
            if (
                    (mg->mg_type == PERL_MAGIC_ext)
                 && (mg->mg_virtual == &null_mg_vtbl)
            ) {
                private_sv_data *pdata = (private_sv_data*)mg->mg_ptr;

                /* We're done with these SVs, release them */
                SvREFCNT_dec(pdata->name);
                SvREFCNT_dec(pdata->data);

                pdata->name = NULL;
                pdata->data = NULL;

                /* And free our struct */
                Safefree(pdata);

                mg->mg_ptr = NULL;
            }
        }
    }
