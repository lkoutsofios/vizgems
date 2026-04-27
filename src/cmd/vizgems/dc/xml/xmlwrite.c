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
#include <vmalloc.h>
#include <swift.h>
#include "xml.h"

void XMLwriteksh (Sfio_t *fp, XMLnode_t *nodep, int level, int sflag) {
    int ni, i;

    if (nodep->type == XML_TYPE_TEXT) {
        for (i = 0; nodep->text[i]; i++)
            if (nodep->text[i] == '\n' || nodep->text[i] == '\r')
                nodep->text[i] = ' ';
            else if (nodep->text[i] == '\'')
                nodep->text[i] = ' ';
        if (sflag)
            sfprintf (fp, "'%s'", nodep->text);
        else if (nodep->indexplusone > 1)
            sfprintf (fp, "_txt_%d='%s'", nodep->indexplusone - 1, nodep->text);
        else
            sfprintf (fp, "_txt='%s'", nodep->text);
    } else {
        if (sflag && ((
            nodep->nodem == 1 && nodep->nodes[0]->type == XML_TYPE_TEXT
        ) || (
            nodep->nodem == 0
        ))) {
            if (nodep->indexplusone > 1)
                sfprintf (fp, "%s_%d=", nodep->tag, nodep->indexplusone - 1);
            else
                sfprintf (fp, "%s=", nodep->tag);
        } else if (level > 0 && nodep->indexplusone > 1)
            sfprintf (fp, "%s_%d=(", nodep->tag, nodep->indexplusone - 1);
        else
            sfprintf (fp, "%s=(", nodep->tag);
        for (ni = 0; ni < nodep->nodem; ni++)
            XMLwriteksh (fp, nodep->nodes[ni], level + 1, sflag);
        if (sflag && ((
            nodep->nodem == 1 && nodep->nodes[0]->type == XML_TYPE_TEXT
        ) || (
            nodep->nodem == 0
        )))
            sfprintf (fp, ";");
        else
            sfprintf (fp, ")");
    }
    if (level == 0)
        sfprintf (fp, "\n");
}

void XMLwriteascii (Sfio_t *fp, XMLnode_t *nodep, int indent) {
    int ni;
    int i;

    for (i = 0; i < indent; i++)
        sfprintf (fp, "  ");
    if (nodep->type == XML_TYPE_TEXT) {
        sfprintf (fp, "%s\n", nodep->text);
    } else {
        if (nodep->indexplusone > 0)
            sfprintf (fp, "%s(%d)\n", nodep->tag, nodep->indexplusone - 1);
        else
            sfprintf (fp, "%s\n", nodep->tag);
        for (ni = 0; ni < nodep->nodem; ni++)
            XMLwriteascii (fp, nodep->nodes[ni], indent + 1);
    }
}
