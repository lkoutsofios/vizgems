#!/bin/ksh
########################################################################
#                                                                      #
#              This software is part of the swift package              #
#          Copyright (c) 1996-2022 AT&T Intellectual Property          #
#                      and is licensed under the                       #
#                 Eclipse Public License, Version 1.0                  #
#                    by AT&T Intellectual Property                     #
#                                                                      #
#                A copy of the License is available at                 #
#          http://www.eclipse.org/org/documents/epl-v10.html           #
#         (with md5 checksum b35adb5213ca9657e911e9befb180842)         #
#                                                                      #
#              Information and Software Systems Research               #
#                            AT&T Research                             #
#                           Florham Park NJ                            #
#                                                                      #
#              Lefteris Koutsofios <ek@research.att.com>               #
#                                                                      #
########################################################################
########################################################################
#             Copyright (c) 2022-2026 Lefteris Koutsofios              #
########################################################################

exitfile=$VG_DSCOPESDIR/exit.schedule
lockfile=$VG_DSCOPESDIR/lock.schedule

if [[ -f $exitfile ]] then
    exit
fi
set -o noclobber
if ! command exec 3> ${lockfile}; then
    if kill -0 $(< ${lockfile}); then
        exit 0
    else
        rm -f ${lockfile}
        exit 0
    fi
fi 2> /dev/null
print -u3 $$
set +o noclobber

trap 'rm -f ${lockfile}' HUP QUIT TERM KILL EXIT

mkdir -p $VG_DSCOPESDIR
cd $VG_DSCOPESDIR || {
    print -u2 vg_scheduler: cannot cd $VG_DSCOPESDIR; exit 1
}

[[ -f ./etc/scheduler.info ]] && . ./etc/scheduler.info

timefile=./etc/time.diff

vgsched \
    -ld $VG_DSCOPESDIR/logs -ef $exitfile -j ${VG_SCHEDJOBS:-32} -tf $timefile \
    -rt ${VG_RECTIME:-schedule} \
schedule
