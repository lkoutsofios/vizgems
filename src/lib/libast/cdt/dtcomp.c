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
/*
 * backwards binary compatibility
 */

#define DTCODE
#include <astcdt.h>

#if defined(__EXPORT__)
#define extern	__EXPORT__
#endif

#undef astdtflatten
extern astDtlink_t* astdtflatten(astDt_t* d)
{
	return (astDtlink_t*)(*(_DT(d)->searchf))((d),(Void_t*)(0),DT_FLATTEN);
}

#undef astdtextract
extern astDtlink_t* astdtextract(astDt_t* d)
{
	return (astDtlink_t*)(*(_DT(d)->searchf))((d),(Void_t*)(0),DT_EXTRACT);
}

#undef astdtrestore
extern astDtlink_t* astdtrestore(astDt_t* d, Void_t* l)
{
	return (astDtlink_t*)(*(_DT(d)->searchf))((d),(l),DT_RESTORE);
}

#undef astdtsize
extern ssize_t astdtsize(astDt_t* d)
{
	return (ssize_t)(*(_DT(d)->searchf))((d),(Void_t*)(0),DT_STAT);
}

#undef astdtstat
extern ssize_t astdtstat(astDt_t* d)
{
	return (ssize_t)(*(_DT(d)->searchf))((d),(Void_t*)(0),DT_STAT);
}
