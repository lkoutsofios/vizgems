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
#ifndef VG_GVC_WRAPPER_H
#define VG_GVC_WRAPPER_H

#define GVW_AGRAPH 0
#define GVW_AGNODE 1
#define GVW_AGEDGE 2

int GVWinit (void);
void *GVWagopen (char *name);
void *GVWagsubg (void *root, char *name, int create);
int GVWagclose (void *gp);
void *GVWagnode (void *gp, char *name, int create);
void *GVWagedge (void *gp, void *tail, void *head, char *name, int create);
void *GVWagattr (void *root, int kind, char *name, char *defval);
int GVWagxset (void *obj, void *sym, char *val);
char *GVWagxget (void *obj, void *sym);
int GVWlayout (void *gp, char *style);
int GVWrender (void *gp, int debug);
int GVWfreelayout (void *gp);

#endif
