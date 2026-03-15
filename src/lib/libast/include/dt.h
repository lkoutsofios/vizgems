/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1985-2011 AT&T Intellectual Property          *
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
*                 Glenn Fowler <gsf@research.att.com>                  *
*                  David Korn <dgk@research.att.com>                   *
*                   Phong Vo <kpv@research.att.com>                    *
*                                                                      *
***********************************************************************/
#pragma prototyped

#ifndef _DT_H
#define _DT_H		1

#include <astcdt.h>
#include <vmalloc.h>

#if _BLD_cdt && defined(__EXPORT__)
#define extern		__EXPORT__
#endif

extern Dt_t*		astdtnew(Vmalloc_t*, astDtdisc_t*, astDtmethod_t*);
extern Dt_t*		_astdtnew(Vmalloc_t*, astDtdisc_t*, astDtmethod_t*, unsigned long);

#undef	extern

#define astdtnew(v,d,m)	_astdtnew(v,d,m,CDT_VERSION)

#endif
