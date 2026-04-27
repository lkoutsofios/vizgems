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
#include <errno.h>
#include <tm.h>
#include <sys/types.h>
#include <swift.h>
#include <xml.h>
#include "sched.h"

int schedulelog (char *logdir, time_t t) {
    char logfile[PATH_MAX], buf[1024];

    tmfmt (buf, 1024, "%Y%m%d-%H%M%S", &t);
    sfsprintf (logfile, PATH_MAX, "%s/schedule.%s.log", logdir, buf);
    if (!sfopen (sfstderr, logfile, "w")) {
        SUwarning (0, "schedulelog", "cannot create logfile %s", logfile);
        return -1;
    }
    return 0;
}
