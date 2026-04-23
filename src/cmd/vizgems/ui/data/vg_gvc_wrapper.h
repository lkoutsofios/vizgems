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
