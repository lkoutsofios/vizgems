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

int AGGRsum (AGGRfile_t *iafp, int dir, int oper, AGGRfile_t *oafp) {
    int keytype, keylen, valtype, vallen, framen, itemn;
    int itemi;
    int rtn;

    if (
        !iafp || dir < 0 || dir >= SUM_DIR_MAXID ||
        oper < 0 || oper >= SUM_OPER_MAXID || !oafp || oafp->ad.keyn != 0
    ) {
        SUwarning (
            1, "AGGRsum", "bad arguments: %x %d %x %d",
            iafp, dir, oafp, oafp->ad.keyn
        );
        return -1;
    }
    keytype = iafp->hdr.keytype;
    keylen = iafp->ad.keylen;
    valtype = iafp->hdr.valtype;
    vallen = iafp->hdr.vallen;
    if (
        oafp->hdr.keytype != keytype ||
        oafp->ad.keylen != keylen ||
        oafp->hdr.vallen / AGGRtypelens[oafp->hdr.valtype] !=
        vallen / AGGRtypelens[valtype]
    ) {
        SUwarning (1, "AGGRsum", "incompatible files");
        return -1;
    }
    if (dir == SUM_DIR_FRAMES)
        framen = 1, itemn = iafp->ad.itemn;
    else
        framen = iafp->hdr.framen, itemn = 1;
    if (dir == SUM_DIR_FRAMES) {
        if (_aggrdictcopy (iafp, oafp) == -1)
            goto abortAGGRsum;
    } else if (iafp->ad.rootp) {
        switch (oafp->ad.keylen) {
        case -1:
            itemi = _aggrdictlookupvar (oafp, iafp->ad.rootp->keyp, -1, TRUE);
            break;
        default:
            itemi = _aggrdictlookupfixed (oafp, iafp->ad.rootp->keyp, -1, TRUE);
            break;
        }
        if (itemi == -1)
            goto abortAGGRsum;
    } else
        itemn = 0;
    if (_aggrgrow (oafp, itemn, framen) == -1)
        goto abortAGGRsum;
    rtn = _aggrsumrun (
        iafp, dir, oafp, iafp->hdr.valtype, oafp->hdr.valtype, oper
    );
    return rtn;

abortAGGRsum:
    SUwarning (1, "AGGRsum", "sum failed");
    return -1;
}
