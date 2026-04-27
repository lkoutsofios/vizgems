/***********************************************************************
*                                                                      *
*              This software is part of the swift package              *
*          Copyright (c) 1996-2022 AT&T Intellectual Property          *
*                      and is licensed under the                       *
*                 Eclipse Public License, Version 1.0                  *
*                    by AT&T Intellectual Property                     *
*                                                                      *
*                A copy of the License is available at                 *
*          http://www.eclipse.org/org/documents/epl-v10.html           *
*         (with md5 checksum b35adb5213ca9657e911e9befb180842)         *
*                                                                      *
*              Information and Software Systems Research               *
*                            AT&T Research                             *
*                           Florham Park NJ                            *
*                                                                      *
*              Lefteris Koutsofios <ek@research.att.com>               *
*                                                                      *
***********************************************************************/
/***********************************************************************
*             Copyright (c) 2022-2026 Lefteris Koutsofios              *
***********************************************************************/
#pragma prototyped

#include <ast.h>
#include <swift.h>
#include "pmem.h"

typedef struct a_s {
    int i, j;
} a_t;

typedef struct b_s {
    a_t *a1, *a2;
} b_t;

static b_t *bp;

static void emit (void);

int main (int argc, char **argv) {
    a_t *zp, *ap;
    int compact = FALSE;

    if (strcmp (argv[1], "compact") == 0)
        compact = TRUE, argv++;
    if (PMinit (argv[1], 1024, emit, compact) == -1)
        SUerror ("main", "PMinit failed");
    if (!(bp = PMgetanchor ())) {
        sfprintf (sfstdout, "NEW\n");
        if (!(bp = PMalloc (sizeof (b_t))))
            SUerror ("main", "alloc for b failed");
        if (!(zp = PMalloc (1010)))
            SUerror ("main", "alloc for z failed");
        if (!(ap = PMalloc (sizeof (a_t))))
            SUerror ("main", "alloc for a1 failed");
        bp->a1 = ap, ap->i = 13, ap->j = 555555555;
        if (!(ap = PMalloc (sizeof (a_t))))
            SUerror ("main", "alloc for a2 failed");
        bp->a2 = ap, ap->i = 53, ap->j = 111111111;
        PMfree (zp);
        PMsetanchor (bp);
    }
    sfprintf (sfstdout, "bp = %x\n", bp);
    sfprintf (sfstdout, "bp->a1 = %x %d %d\n", bp->a1, bp->a1->i, bp->a1->j);
    sfprintf (sfstdout, "bp->a2 = %x %d %d\n", bp->a2, bp->a2->i, bp->a2->j);
    if (PMterm (argv[2]) == -1)
        SUerror ("main", "PMterm failed");
}

static void emit (void) {
    PMptrwrite (&bp->a1);
    PMptrwrite (&bp->a2);
}
