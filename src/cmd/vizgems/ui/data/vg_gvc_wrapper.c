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
#include <stdio.h>
#include <dlfcn.h>
#include "vg_gvc_wrapper.h"

/*
 * Local type definitions — avoids including graphviz headers which pull in
 * graphviz's incompatible CDT implementation.  Both structs are stable across
 * the graphviz 2.x releases we target.
 */
typedef struct {
    unsigned directed:1;
    unsigned strict:1;
    unsigned no_loop:1;
    unsigned maingraph:1;
    unsigned flatlock:1;
    unsigned no_write:1;
    unsigned has_attrs:1;
    unsigned has_cmpnd:1;
} GVW_Agdesc_t;

typedef struct {
    const char *name;
    void       *address;
} GVW_lt_symlist_t;

/* opaque graphviz context handle */
static void *gvc;

/* pointer to libcgraph's Agdirected global (fetched via dlsym) */
static GVW_Agdesc_t *p_Agdirected;

static GVW_lt_symlist_t lt_symlist[5];

/* cgraph function pointers */
static void *(*f_agopen)(char *, GVW_Agdesc_t, void *);
static void *(*f_agsubg)(void *, char *, int);
static int   (*f_agclose)(void *);
static void *(*f_agnode)(void *, char *, int);
static void *(*f_agedge)(void *, void *, void *, char *, int);
static void *(*f_agattr)(void *, int, char *, char *);
static int   (*f_agxset)(void *, void *, char *);
static char *(*f_agxget)(void *, void *);

/* gvc function pointers */
static void *(*f_gvContextPlugins)(GVW_lt_symlist_t *, int);
static int   (*f_gvLayout)(void *, void *, char *);
static int   (*f_gvRender)(void *, void *, const char *, FILE *);
static int   (*f_gvFreeLayout)(void *, void *);

#define LOADSYM(handle, var, symname) \
    do { \
        *(void **)&(var) = dlsym((handle), (symname)); \
        if (!(var)) { \
            fprintf(stderr, "GVWinit: cannot find symbol %s: %s\n", \
                    (symname), dlerror()); \
            return -1; \
        } \
    } while (0)

int GVWinit (void) {
    void *hcgraph, *hgvc, *hp;
    int n = 0;

    /*
     * RTLD_LOCAL  — symbols stay out of the global namespace; AST's dtopen
     *               etc. are not displaced by graphviz's incompatible CDT.
     * RTLD_DEEPBIND — graphviz resolves its own CDT calls against its own
     *               copy, not whatever dtopen happens to be in global scope.
     */
    hcgraph = dlopen("libcgraph.so.6", RTLD_LOCAL | RTLD_LAZY | RTLD_DEEPBIND);
    if (!hcgraph) {
        fprintf(stderr, "GVWinit: cannot load libcgraph.so.6: %s\n", dlerror());
        return -1;
    }
    hgvc = dlopen("libgvc.so.6", RTLD_LOCAL | RTLD_LAZY | RTLD_DEEPBIND);
    if (!hgvc) {
        fprintf(stderr, "GVWinit: cannot load libgvc.so.6: %s\n", dlerror());
        return -1;
    }

    p_Agdirected = (GVW_Agdesc_t *) dlsym(hcgraph, "Agdirected");
    if (!p_Agdirected) {
        fprintf(stderr, "GVWinit: cannot find Agdirected: %s\n", dlerror());
        return -1;
    }

    LOADSYM(hcgraph, f_agopen,  "agopen");
    LOADSYM(hcgraph, f_agsubg,  "agsubg");
    LOADSYM(hcgraph, f_agclose, "agclose");
    LOADSYM(hcgraph, f_agnode,  "agnode");
    LOADSYM(hcgraph, f_agedge,  "agedge");
    LOADSYM(hcgraph, f_agattr,  "agattr");
    LOADSYM(hcgraph, f_agxset,  "agxset");
    LOADSYM(hcgraph, f_agxget,  "agxget");

    LOADSYM(hgvc, f_gvContextPlugins, "gvContextPlugins");
    LOADSYM(hgvc, f_gvLayout,         "gvLayout");
    LOADSYM(hgvc, f_gvRender,         "gvRender");
    LOADSYM(hgvc, f_gvFreeLayout,     "gvFreeLayout");

    /* load layout/render plugins; RTLD_DEEPBIND lets them resolve cgraph/gvc
     * symbols from their own local scope rather than from AST's global CDT */
    hp = dlopen("libgvplugin_dot_layout.so", RTLD_LOCAL | RTLD_LAZY | RTLD_DEEPBIND);
    if (!hp) {
        fprintf(stderr, "GVWinit: cannot load libgvplugin_dot_layout.so: %s\n", dlerror());
        return -1;
    }
    lt_symlist[n].name = "gvplugin_dot_layout_LTX_library";
    if (!(lt_symlist[n].address = dlsym(hp, lt_symlist[n].name))) {
        fprintf(stderr, "GVWinit: cannot find gvplugin_dot_layout_LTX_library\n");
        return -1;
    }
    n++;

    hp = dlopen("libgvplugin_neato_layout.so", RTLD_LOCAL | RTLD_LAZY | RTLD_DEEPBIND);
    if (!hp) {
        fprintf(stderr, "GVWinit: cannot load libgvplugin_neato_layout.so: %s\n", dlerror());
        return -1;
    }
    lt_symlist[n].name = "gvplugin_neato_layout_LTX_library";
    if (!(lt_symlist[n].address = dlsym(hp, lt_symlist[n].name))) {
        fprintf(stderr, "GVWinit: cannot find gvplugin_neato_layout_LTX_library\n");
        return -1;
    }
    n++;

    hp = dlopen("libgvplugin_gd.so", RTLD_LOCAL | RTLD_LAZY | RTLD_DEEPBIND);
    if (!hp) {
        fprintf(stderr, "GVWinit: cannot load libgvplugin_gd.so: %s\n", dlerror());
        return -1;
    }
    lt_symlist[n].name = "gvplugin_gd_LTX_library";
    if (!(lt_symlist[n].address = dlsym(hp, lt_symlist[n].name))) {
        fprintf(stderr, "GVWinit: cannot find gvplugin_gd_LTX_library\n");
        return -1;
    }
    n++;

    hp = dlopen("libgvplugin_core.so", RTLD_LOCAL | RTLD_LAZY | RTLD_DEEPBIND);
    if (!hp) {
        fprintf(stderr, "GVWinit: cannot load libgvplugin_core.so: %s\n", dlerror());
        return -1;
    }
    lt_symlist[n].name = "gvplugin_core_LTX_library";
    if (!(lt_symlist[n].address = dlsym(hp, lt_symlist[n].name))) {
        fprintf(stderr, "GVWinit: cannot find gvplugin_core_LTX_library\n");
        return -1;
    }
    n++;

    lt_symlist[n].name    = NULL;
    lt_symlist[n].address = NULL;

    if (!(gvc = f_gvContextPlugins(lt_symlist, 0))) {
        fprintf(stderr, "GVWinit: cannot create gvc context\n");
        return -1;
    }
    return 0;
}

void *GVWagopen (char *name) {
    return f_agopen(name, *p_Agdirected, NULL);
}

void *GVWagsubg (void *root, char *name, int create) {
    return f_agsubg(root, name, create);
}

int GVWagclose (void *gp) {
    f_agclose(gp);
    return 0;
}

void *GVWagnode (void *gp, char *name, int create) {
    return f_agnode(gp, name, create);
}

void *GVWagedge (void *gp, void *tail, void *head, char *name, int create) {
    return f_agedge(gp, tail, head, name, create);
}

void *GVWagattr (void *root, int kind, char *name, char *defval) {
    return f_agattr(root, kind, name, defval);
}

int GVWagxset (void *obj, void *sym, char *val) {
    return f_agxset(obj, sym, val);
}

char *GVWagxget (void *obj, void *sym) {
    return f_agxget(obj, sym);
}

int GVWlayout (void *gp, char *style) {
    return f_gvLayout(gvc, gp, style);
}

int GVWrender (void *gp, int debug) {
    return f_gvRender(gvc, gp, "xdot", debug ? stderr : NULL);
}

int GVWfreelayout (void *gp) {
    return f_gvFreeLayout(gvc, gp);
}
