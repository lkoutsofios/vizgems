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
/* A really simple argument processor from Plan 9 */

char *argv0;
#define ARGBEGIN for((argv0? 0: (argv0 = *argv)),argv++,argc--;\
    argv[0] && (char)argv[0][0]=='-' && argv[0][1];\
    argc--, argv++) {\
    char *_args, *_argt;\
    char _argc;\
    _args = &argv[0][1];\
    if((char)_args[0]=='-' && _args[1]==0){\
        argc--; argv++; break;\
    }\
    _argc = 0;\
    while(*_args && (_argc = (*_args++)))\
        switch((char)_argc)
#define ARGEND ;};
#define ARGF() (_argt=_args, _args="",\
    (*_argt? _argt: argv[1]? (argc--, *++argv): 0))
#define ARGC() _argc
