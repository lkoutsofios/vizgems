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

#ifndef _SWIFT_H
#define _SWIFT_H

#include <ast.h>
#include <vmalloc.h>

#ifndef TRUE
#define TRUE  1
#endif
#ifndef FALSE
#define FALSE 0
#endif

#define SU_AUTH_CLIENT 1
#define SU_AUTH_SERVER 2

#if _ast_intswap == 7
#define SWIFT_BIGENDIAN 0
#define SWIFT_LITTLEENDIAN 1
#define SWIFT_ENDIAN 0
#else
#define SWIFT_BIGENDIAN 1
#define SWIFT_LITTLEENDIAN 0
#define SWIFT_ENDIAN 1
#endif

_BEGIN_EXTERNS_ /* public data */
#if _BLD_swift && defined(__EXPORT__)
#define __PUBLIC_DATA__ __EXPORT__
#else
#if !_BLD_swift && defined(__IMPORT__)
#define __PUBLIC_DATA__ __IMPORT__
#else
#define __PUBLIC_DATA__
#endif
#endif

extern __PUBLIC_DATA__ int SUwarnlevel;
extern __PUBLIC_DATA__ int SUexitcode;

#undef __PUBLIC_DATA__

#if _BLD_swift && defined(__EXPORT__)
#define extern  __EXPORT__
#endif

extern Sfio_t *SUsetupinput (Sfio_t *, size_t);
extern Sfio_t *SUsetupoutput (char *, Sfio_t *, size_t);

extern int SUencodekey (unsigned char *, unsigned char *);
extern int SUdecodekey (unsigned char *, unsigned char *);
extern int SUauth (int, int, char *, unsigned char *);
extern void SUhmac (
    unsigned char *, int, unsigned char *, int, unsigned char [33]
);

extern int SWenc (Vmalloc_t *, unsigned char *, unsigned char **);
extern int SWdec (Vmalloc_t *, unsigned char *, unsigned char **);

extern void SUerror (char *, char *, ...);
extern void SUwarning (int, char *, char *, ...);
extern void SUmessage (int, char *, char *, ...);
extern void SUusage (int, char *, char *);
extern int SUcanseek (Sfio_t *);

#undef extern
_END_EXTERNS_

#endif /* _SWIFT_H */
