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

/*	Hash table with chaining for collisions.
**
**      Written by Kiem-Phong Vo (05/25/96)
*/

/* these bits should be outside the scope of DT_METHODS */
#define H_FIXED		0100000	/* table size is fixed	*/
#define	H_FLATTEN	0200000	/* table was flattened	*/

#define HLOAD(n)	(n)	/* load one-to-one	*/

/* internal data structure for hash table with chaining */
typedef struct _dthash_s
{	astDtdata_t	data;
	int		type; 
	astDtlink_t*	here;	/* fingered object	*/
	astDtlink_t**	htbl;	/* hash table slots 	*/
	ssize_t		tblz;	/* size of hash table 	*/
} astDthash_t;

/* make/resize hash table */
static int htable(astDt_t* dt)
{
	astDtlink_t	**htbl, **t, **endt, *l, *next;
	ssize_t		n, k;
	astDtdisc_t	*disc = dt->disc;
	astDthash_t	*hash = (astDthash_t*)dt->data;

	if((n = hash->tblz) > 0 && (hash->type&H_FIXED) )
		return 0; /* fixed size table */

	if(n == 0 && disc && disc->eventf) /* let user have input */
	{	if((*disc->eventf)(dt, DT_HASHSIZE, &n, disc) > 0 )
		{	if(n < 0) /* fix table size */
			{	hash->type |= H_FIXED;
				n = -n;
			}
		}
	}

	/* table size should be a power of 2 */
	n = n < HLOAD(hash->data.size) ? HLOAD(hash->data.size) : n;
	for(k = (1<<DT_HTABLE); k < n; )
		k *= 2;
	if((n = k) <= hash->tblz)
		return 0;

	/* allocate new table */
	if(!(htbl = (astDtlink_t**)(*dt->memoryf)(dt, 0, n*sizeof(astDtlink_t*), disc)) )
	{	DTERROR(dt, "Error in allocating an extended hash table");
		return -1;
	}
	memset(htbl, 0, n*sizeof(astDtlink_t*));

	/* move objects into new table */
	for(endt = (t = hash->htbl) + hash->tblz; t < endt; ++t)
	{	for(l = *t; l; l = next)
		{	next = l->_rght;
			l->_rght = htbl[k = l->_hash&(n-1)];
			htbl[k] = l;
		}
	}

	if(hash->htbl) /* free old table and set new table */
		(void)(*dt->memoryf)(dt, hash->htbl, 0, disc);
	hash->htbl = htbl;
	hash->tblz = n;

	return 0;
}

static Void_t* hclear(astDt_t* dt)
{
	astDtlink_t	**t, **endt, *l, *next;
	astDthash_t	*hash = (astDthash_t*)dt->data;

	hash->here = NIL(astDtlink_t*);
	hash->data.size = 0;

	for(endt = (t = hash->htbl) + hash->tblz; t < endt; ++t)
	{	for(l = *t; l; l = next)
		{	next = l->_rght;
			_dtfree(dt, l, DT_DELETE);
		}
		*t = NIL(astDtlink_t*);
	}

	return NIL(Void_t*);
}

static Void_t* hfirst(astDt_t* dt)
{
	astDtlink_t	**t, **endt, *l;
	astDthash_t	*hash = (astDthash_t*)dt->data;

	for(endt = (t = hash->htbl) + hash->tblz; t < endt; ++t)
	{	if(!(l = *t) )
			continue;
		hash->here = l;
		return _DTOBJ(dt->disc, l);
	}

	return NIL(Void_t*);
}

static Void_t* hnext(astDt_t* dt, astDtlink_t* l)
{
	astDtlink_t	**t, **endt, *next;
	astDthash_t	*hash = (astDthash_t*)dt->data;

	if((next = l->_rght) )
	{	hash->here = next;
		return _DTOBJ(dt->disc, next);
	}
	else
	{	t = hash->htbl + (l->_hash & (hash->tblz-1)) + 1;
		endt = hash->htbl + hash->tblz;
		for(; t < endt; ++t)
		{	if(!(l = *t) )
				continue;
			hash->here = l;
			return _DTOBJ(dt->disc, l);
		}
		return NIL(Void_t*);
	}
}

static Void_t* hflatten(astDt_t* dt, int type)
{
	astDtlink_t	**t, **endt, *head, *tail, *l;
	astDthash_t	*hash = (astDthash_t*)dt->data;

	if(type == DT_FLATTEN || type == DT_EXTRACT)
	{	head = tail = NIL(astDtlink_t*);
		for(endt = (t = hash->htbl) + hash->tblz; t < endt; ++t)
		{	for(l = *t; l; l = l->_rght)
			{	if(tail)
					tail = (tail->_rght = l);
				else	head = tail = l;

				*t = type == DT_FLATTEN ? tail : NIL(astDtlink_t*);
			}
		}

		if(type == DT_FLATTEN)
		{	hash->here = head;
			hash->type |= H_FLATTEN;
		}
		else	hash->data.size = 0;

		return (Void_t*)head;
	}
	else /* restoring a previous flattened list */
	{	head = hash->here;
		for(endt = (t = hash->htbl) + hash->tblz; t < endt; ++t)
		{	if(*t == NIL(astDtlink_t*))
				continue;

			/* find the tail of the list for this slot */
			for(l = head; l && l != *t; l = l->_rght)
				;
			if(!l) /* something is seriously wrong */
				return NIL(Void_t*);

			*t = head; /* head of list for this slot */
			head = l->_rght; /* head of next list */
			l->_rght = NIL(astDtlink_t*);
		}

		hash->here = NIL(astDtlink_t*);
		hash->type &= ~H_FLATTEN;

		return NIL(Void_t*);
	}
}

static Void_t* hlist(astDt_t* dt, astDtlink_t* list, int type)
{
	Void_t		*obj;
	astDtlink_t	*l, *next;
	astDtdisc_t	*disc = dt->disc;

	if(type&DT_FLATTEN)
		return hflatten(dt, DT_FLATTEN);
	else if(type&DT_EXTRACT)
		return hflatten(dt, DT_EXTRACT);
	else /* if(type&DT_RESTORE) */
	{	dt->data->size = 0;
		for(l = list; l; l = next)
		{	next = l->_rght;
			obj = _DTOBJ(disc,l);
			if((*dt->meth->searchf)(dt, (Void_t*)l, DT_RELINK) == obj)
				dt->data->size += 1;
		}
		return (Void_t*)list;
	}
}

static Void_t* hstat(astDt_t* dt, astDtstat_t* st)
{
	ssize_t		n;
	astDtlink_t	**t, **endt, *l;
	astDthash_t	*hash = (astDthash_t*)dt->data;

	if(st)
	{	memset(st, 0, sizeof(astDtstat_t));
		st->meth  = dt->meth->type;
		st->size  = hash->data.size;
		st->space = sizeof(astDthash_t) + hash->tblz*sizeof(astDtlink_t*) +
			    (dt->disc->link >= 0 ? 0 : hash->data.size*sizeof(astDthold_t));

		for(endt = (t = hash->htbl) + hash->tblz; t < endt; ++t)
		{	for(n = 0, l = *t; l; l = l->_rght)
				n += 1;
			st->mlev = n > st->mlev ? n : st->mlev;
			if(n < DT_MAXSIZE) /* if chain length is small */
			{	st->msize = n > st->msize ? n : st->msize;
				st->lsize[n] += n;
			}
		}
	}

	return (Void_t*)hash->data.size;
}

#if __STD_C
static Void_t* astdthashchain(astDt_t* dt, Void_t* obj, int type)
#else
static Void_t* astdthashchain(dt,obj,type)
astDt_t*	dt;
Void_t*	obj;
int	type;
#endif
{
	astDtlink_t	*lnk, *pp, *ll, *p, *l, **tbl;
	Void_t		*key, *k, *o;
	uint		hsh;
	astDtdisc_t	*disc = dt->disc;
	astDthash_t	*hash = (astDthash_t*)dt->data;

	type = DTTYPE(dt,type); /* map type for upward compatibility */
	if(!(type&DT_OPERATIONS) )
		return NIL(Void_t*);

	DTSETLOCK(dt);

	if(!hash->htbl && htable(dt) < 0 ) /* initialize hash table */
		DTRETURN(obj, NIL(Void_t*));

	if(hash->type&H_FLATTEN) /* restore flattened list */
		hflatten(dt, 0);

	if(type&(DT_FIRST|DT_LAST|DT_CLEAR|DT_EXTRACT|DT_RESTORE|DT_FLATTEN|DT_STAT) )
	{	if(type&(DT_FIRST|DT_LAST) )
			DTRETURN(obj, hfirst(dt));
		else if(type&DT_CLEAR)
			DTRETURN(obj, hclear(dt));
		else if(type&DT_STAT)
			DTRETURN(obj, hstat(dt, (astDtstat_t*)obj));
		else /*if(type&(DT_EXTRACT|DT_RESTORE|DT_FLATTEN))*/
			DTRETURN(obj, hlist(dt, (astDtlink_t*)obj, type));
	}

	lnk = hash->here; /* fingered object */
	hash->here = NIL(astDtlink_t*);

	if(lnk && obj == _DTOBJ(disc,lnk))
	{	if(type&DT_SEARCH)
			DTRETURN(obj, obj);
		else if(type&(DT_NEXT|DT_PREV) )
			DTRETURN(obj, hnext(dt,lnk));
	}

	if(type&DT_RELINK)
	{	lnk = (astDtlink_t*)obj;
		obj = _DTOBJ(disc,lnk);
		key = _DTKEY(disc,obj);
	}
	else 
	{	lnk = NIL(astDtlink_t*);
		if((type&DT_MATCH) )
		{	key = obj;
			obj = NIL(Void_t*);
		}
		else	key = _DTKEY(disc,obj);
	}
	hsh = _DTHSH(dt,key,disc);

	tbl = hash->htbl + (hsh & (hash->tblz-1));
	pp = ll = NIL(astDtlink_t*);
	for(p = NIL(astDtlink_t*), l = *tbl; l; p = l, l = l->_rght)
	{	if(hsh == l->_hash)
		{	o = _DTOBJ(disc,l); k = _DTKEY(disc,o);
			if(_DTCMP(dt, key, k, disc) != 0 )
				continue;
			else if((type&(DT_REMOVE|DT_NEXT|DT_PREV)) && o != obj )
			{	if(type&(DT_NEXT|DT_PREV) )
					{ pp = p; ll = l; }
				continue;
			}
			else	break;
		}
	}
	if(l) /* found an object, use it */ 
		{ pp = p; ll = l; }

	if(ll) /* found object */
	{	if(type&(DT_SEARCH|DT_MATCH|DT_ATLEAST|DT_ATMOST) )
		{	hash->here = ll;
			DTRETURN(obj, _DTOBJ(disc,ll));
		}
		else if(type & (DT_NEXT|DT_PREV) )
			DTRETURN(obj, hnext(dt, ll));
		else if(type & (DT_DELETE|DT_DETACH|DT_REMOVE) )
		{	hash->data.size -= 1;
			if(pp)
				pp->_rght = ll->_rght;
			else	*tbl = ll->_rght;
			_dtfree(dt, ll, type);
			DTRETURN(obj, _DTOBJ(disc,ll));
		}
		else
		{	/**/DEBUG_ASSERT(type&(DT_INSERT|DT_ATTACH|DT_APPEND|DT_RELINK));
			if(!(dt->meth->type&DT_BAG) )
			{	if(type&(DT_INSERT|DT_APPEND|DT_ATTACH) )
					type |= DT_SEARCH; /* for announcement */
				else if(lnk && (type&DT_RELINK) )
					_dtfree(dt, lnk, DT_DELETE);
				DTRETURN(obj, _DTOBJ(disc,ll));
			}
			else	goto do_insert;
		}
	}
	else /* no matching object */
	{	if(!(type&(DT_INSERT|DT_APPEND|DT_ATTACH|DT_RELINK)) )
			DTRETURN(obj, NIL(Void_t*));

	do_insert: /* inserting a new object */
		if(hash->tblz < HLOAD(hash->data.size) )
		{	htable(dt); /* resize table */
			tbl = hash->htbl + (hsh & (hash->tblz-1));
		}

		if(!lnk) /* inserting a new object */
		{	if(!(lnk = _dtmake(dt, obj, type)) )
				DTRETURN(obj, NIL(Void_t*));
			hash->data.size += 1;
		}

		lnk->_hash = hsh; /* memoize the hash value */
		lnk->_rght = *tbl; *tbl = lnk;

		hash->here = lnk;
		DTRETURN(obj, _DTOBJ(disc,lnk));
	}

dt_return:
	DTANNOUNCE(dt, obj, type);
	DTCLRLOCK(dt);
	return obj;
}

static int hashevent(astDt_t* dt, int event, Void_t* arg)
{
	astDthash_t	*hash = (astDthash_t*)dt->data;

	if(event == DT_OPEN)
	{	if(hash)
			return 0;
		if(!(hash = (astDthash_t*)(*dt->memoryf)(dt, 0, sizeof(astDthash_t), dt->disc)) )
		{	DTERROR(dt, "Error in allocating a hash table with chaining");
			return -1;
		}
		memset(hash, 0, sizeof(astDthash_t));
		dt->data = (astDtdata_t*)hash;
		return 1;
	}
	else if(event == DT_CLOSE)
	{	if(!hash)
			return 0;
		if(hash->data.size > 0 )
			(void)hclear(dt);
		if(hash->htbl)
			(void)(*dt->memoryf)(dt, hash->htbl, 0, dt->disc);
		(void)(*dt->memoryf)(dt, hash, 0, dt->disc);
		dt->data = NIL(astDtdata_t*);
		return 0;
	}
	else	return 0;
}

static astDtmethod_t	_Dtset = { astdthashchain, DT_SET, hashevent, "Dtset" };
static astDtmethod_t	_Dtbag = { astdthashchain, DT_BAG, hashevent, "Dtbag" };
__DEFINE__(astDtmethod_t*,astDtset,&_Dtset);
__DEFINE__(astDtmethod_t*,astDtbag,&_Dtbag);

/* backwards compatibility */
#undef	astDthash
#if defined(__EXPORT__)
__EXPORT__
#endif
__DEFINE__(astDtmethod_t*,astDthash,&_Dtset);

#ifdef NoF
NoF(astdthashchain)
#endif
