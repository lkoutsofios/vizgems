/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1985-2012 AT&T Intellectual Property          *
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
#include	"dthdr.h"

/*	Change discipline.
**	dt :	dictionary
**	disc :	discipline
**
**	Written by Kiem-Phong Vo (5/26/96)
*/

#if __STD_C
static Void_t* astdtmemory(astDt_t* dt, Void_t* addr, size_t size, astDtdisc_t* disc)
#else
static Void_t* astdtmemory(dt, addr, size, disc)
astDt_t* 		dt;	/* dictionary			*/
Void_t* 	addr;	/* address to be manipulate	*/
size_t		size;	/* size to obtain		*/
astDtdisc_t* 	disc;	/* discipline			*/
#endif
{
	if(addr)
	{	if(size == 0)
		{	free(addr);
			return NIL(Void_t*);
		}
		else	return realloc(addr,size);
	}
	else	return size > 0 ? malloc(size) : NIL(Void_t*);
}

#if __STD_C
astDtdisc_t* astdtdisc(astDt_t* dt, astDtdisc_t* disc, int type)
#else
astDtdisc_t* astdtdisc(dt,disc,type)
astDt_t*		dt;
astDtdisc_t*	disc;
int		type;
#endif
{
	astDtdisc_t	*old;
	astDtlink_t	*list;

	if(!(old = dt->disc) )	/* initialization call from astdtopen() */
	{	dt->disc = disc;
		if(!(dt->memoryf = disc->memoryf) )
			dt->memoryf = astdtmemory;
		return disc;
	}

	if(!disc) /* only want to know current discipline */
		return old;

	if(old->eventf && (*old->eventf)(dt,DT_DISC,(Void_t*)disc,old) < 0)
		return NIL(astDtdisc_t*);

	if((type & (DT_SAMEHASH|DT_SAMECMP)) != (DT_SAMEHASH|DT_SAMECMP) )
		list = astdtextract(dt); /* grab the list of objects if any */
	else	list = NIL(astDtlink_t*);

	dt->disc = disc;
	if(!(dt->memoryf = disc->memoryf) )
		dt->memoryf = astdtmemory;

	if(list ) /* reinsert extracted objects (with new discipline) */
		astdtrestore(dt, list);

	return old;
}
