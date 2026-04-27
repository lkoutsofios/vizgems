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
#include <regex.h>
#include <swift.h>

typedef struct vid_s {
    int vid;
    char *value;
} vid_t;

typedef struct var_s {
    char *name;
    int type;
    union {
        char *lit;
        int vid;
    } u;
} var_t;

typedef struct alarm_s {
    char *id;
    char *textstr, *textrestr;
    char *textlcss;
    int textlcsn;
    regex_t textcode;
    char *objstr, *objrestr;
    char *objlcss;
    int objlcsn;
    regex_t objcode;
    int statenum;
    int sevnum;
    vid_t *vids;
    int vidl, vidn;
    var_t *vars;
    int varl, varn;
    char *unique;
    int tm, sm;
    char *com;
} alarm_t;

extern int alarmdbload (char *);
extern alarm_t *alarmdbfind (char *, char *, char *);
extern char *alarmdbvars (alarm_t *);
