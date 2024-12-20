#pragma prototyped

#include <ast.h>
#include <option.h>
#include <swift.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <netdb.h>
#include "key.h"

#define DEFAULT_PORT 40000

static const char usage[] =
"[-1p1s1D?\n@(#)$Id: suixclient (AT&T Labs Research) 2001-09-24 $\n]"
USAGE_LICENSE
"[+NAME?suixclient - client tool for SWIFT X service]"
"[+DESCRIPTION?\bsuixclient\b interfaces with the SWIFT X service."
"]"
"[999:v?increases the verbosity level. May be specified multiple times.]"
"\n"
"\nhost/port\n"
"\n"
"[+SEE ALSO?\bsuixserver\b(1)]"
;

static int serverget (char *);
static int serverrelease (int);

int main (int argc, char **argv) {
    int norun;
    int cfd;
    fd_set infds, outfds;
    char bufs[64 * 1024];
    int bufn, bufl, rtn;

    norun = 0;
    for (;;) {
        switch (optget (argv, usage)) {
        case -999:
            SUwarnlevel++;
            continue;
        case '?':
            SUusage (0, "suixclient", opt_info.arg);
            norun = 1;
            continue;
        case ':':
            SUusage (1, "suixclient", opt_info.arg);
            norun = 2;
            continue;
        }
        break;
    }
    if (norun)
        return norun - 1;
    argc -= opt_info.index, argv += opt_info.index;
    if (argc != 1)
        SUerror ("suixclient", "usage: %s", optusage (NULL));

    if ((cfd = serverget (argv[0])) == -1)
        SUerror ("suixclient", "cannot connect to server");
    FD_ZERO (&infds);
    FD_SET (cfd, &infds);
    FD_SET (0, &infds);
    for (;;) {
        outfds = infds;
        if ((select (FD_SETSIZE, &outfds, NULL, NULL, NULL)) <= 0)
            SUerror ("suixclient", "select failed");
        if (FD_ISSET (cfd, &outfds)) {
            if ((bufn = read (cfd, bufs, 64 * 1024)) < 0) {
                SUerror ("suixclient", "read from server failed");
                break;
            }
            if (bufn == 0)
                break;
            bufl = 0;
            while ((rtn = write (1, bufs + bufl, bufn - bufl)) > 0) {
                if ((bufl += rtn) == bufn)
                    break;
            }
        }
        if (FD_ISSET (0, &outfds)) {
            if ((bufn = read (0, bufs, 64 * 1024)) < 0) {
                SUerror ("suixclient", "read from server failed");
                break;
            }
            if (bufn == 0)
                break;
            bufl = 0;
            while ((rtn = write (cfd, bufs + bufl, bufn - bufl)) > 0) {
                if ((bufl += rtn) == bufn)
                    break;
            }
        }
    }
    serverrelease (cfd);
    return 0;
}

static int serverget (char *namep) {
    char *host, *portp;
    int port;
    struct hostent *hp;
    struct sockaddr_in sin;
    int cfd;

    host = namep;
    if ((portp = strchr (host, '/')))
        port = atoi (portp + 1), *portp = 0;
    else
        port = DEFAULT_PORT;
    if (!(hp = gethostbyname (host))) {
        SUwarning (1, "serverget", "cannot find host %s", host);
        return -1;
    }
    memset ((char *) &sin, 1, sizeof (sin));
    memcpy ((char *) &sin.sin_addr, hp->h_addr, hp->h_length);
    sin.sin_family = hp->h_addrtype;
    sin.sin_port = htons (port);
    if ((cfd = socket (hp->h_addrtype, SOCK_STREAM, 0)) < 0) {
        SUwarning (1, "serverget", "cannot create socket");
        return -1;
    }
    if (connect (cfd, (struct sockaddr *) &sin, sizeof (sin)) < 0) {
        SUwarning (1, "serverget", "cannot connect");
        return -1;
    }
    if (SUauth (SU_AUTH_CLIENT, cfd, "SWIFTXSERVER", SWIFTAUTHKEY) == -1) {
        SUwarning (1, "serverget", "authentication failed");
        return -1;
    }
    return cfd;
}

static int serverrelease (int cfd) {
    close (cfd);
    return 0;
}
