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
#ifndef WMI_H

typedef struct state_s {
  BSTR                 url;
  BSTR                 host;
  BSTR                 ns;
  BSTR                 dnu;
  BSTR                 domain;
  BSTR                 user;
  BSTR                 passwd;
  IWbemLocator         *pLoc;
  IWbemServices        *pSvc;
  IEnumWbemClassObject *pEnum;
  IWbemClassObject     *pClsObj;
  IWbemQualifierSet    *pQualSet;
} state_t;

extern int verbose;

state_t *SWMIopen (void);
int SWMIconnect (
  state_t *, const char *, const char *, const char *, const char *
);
int SWMIclose (state_t *);
int SWMIproxysecurity (state_t *, IUnknown *);

int SWMIopnload (char *, char *);
int SWMIopnsave (char *);
int SWMIopnexec (state_t *);

int SWMIlogload (char *, char *);
int SWMIlogsave (char *);
int SWMIlogexec (char *, state_t *);

int SWMIinvload (char *);
int SWMIinvsave (void);
int SWMIinvexec (state_t *, int);

#endif /* WMI_H */
