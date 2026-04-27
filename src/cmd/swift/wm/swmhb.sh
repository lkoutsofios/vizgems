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

PATH=$PATH:/usr/sbin

export SWMROOT=${0%/*}
SWMROOT=${SWMROOT%/*}
. $SWMROOT/bin/swmenv
[[ $SECONDS != *.* ]] && exec $SHELL $0 "$@"

mustrestart=n
for l in $SWMROOT/logs/*_log; do
    if [[ ! -f $l ]] then
        continue
    fi
    ls -l $l | read j1 j2 j3 j4 s j5
    if (( s > 10 * 1024 * 1024 )) then
        print -u2 rotating $l
        rm -f $l.5
        for v in 4 3 2 1; do
            if [[ ! -f $l.$v ]] then
                continue
            fi
            ((vp1 = v + 1))
            mv $l.$v $l.$vp1
        done
        mv $l $l.1
        mustrestart=y
    fi
    touch $l
done

if [[ -x $SWMROOT/bin/apachectl ]] then
    if [[ $mustrestart == y ]] then
        print -u2 restarting web server
        $SWMROOT/bin/apachectl graceful > /dev/null
    else
        $SWMROOT/bin/apachectl start > /dev/null 2>&1
    fi
fi
