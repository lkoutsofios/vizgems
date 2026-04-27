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
#include "sched.h"

int scheduletimediff (char *timefile, time_t *tp) {
    Sfio_t *fp;
    char *line, *s;

    *tp = 0;
    if (!(fp = sfopen (NULL, timefile, "r"))) {
        SUwarning (1, "scheduletimediff", "cannot open timefile %s", timefile);
        return 0;
    }
    if (!(line = sfgetr (fp, '\n', 1))) {
        SUwarning (1, "scheduletimediff", "cannot read timefile %s", timefile);
        sfclose (fp);
        return 0;
    }
    *tp = strtol (line, &s, 10);
    if (s && *s) {
        SUwarning (0, "scheduletimediff", "cannot calculate offset %s", line);
        *tp = 0;
        sfclose (fp);
        return -1;
    }
    sfclose (fp);
    return 0;
}
