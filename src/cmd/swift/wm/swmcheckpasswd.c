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
#include <ast.h>
#include <swift.h>
#include <FEATURE/crypt>
#ifdef _hdr_crypt
#include <crypt.h>
#else
#include <unistd.h>
#endif

int main (int argc, char **argv) {
    char *plain, *encrypted, *result, settings[4];

    plain = argv[1];
    encrypted = argv[2];
    strncpy (settings, encrypted, 2);
    settings[2] = 0;

    result = crypt (plain, settings);
    SUwarning (1, "swmcheckpasswd", "%s / %s", encrypted, result);
    if (strcmp (result, encrypted) == 0)
        return 0;
    else
        return 1;
}
