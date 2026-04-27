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
#define _AGGR_PRIVATE
#include <aggr.h>
#include <aggr_int.h>

int AGGRtopn (
    AGGRfile_t *iafp, int fframei, int lframei,
    AGGRkv_t *kvs, int kvn, int oper
) {
    int rtn;

    if (
        !iafp || fframei < 0 || fframei > lframei ||
        lframei >= iafp->hdr.framen || !kvs || kvn < 1 ||
        oper < 0 || oper >= TOPN_OPER_MAXID
    ) {
        SUwarning (
            1, "AGGRtopn", "bad arguments: %x %d %d %x %d %d",
            iafp, fframei, lframei, kvs, kvn, oper
        );
        return -1;
    }
    rtn = _aggrtopnrun (
        iafp, fframei, lframei, kvs, kvn, iafp->hdr.valtype, oper
    );
    return rtn;
}
