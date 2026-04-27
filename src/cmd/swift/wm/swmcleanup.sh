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

export SWMROOT=${0%/*}
SWMROOT=${SWMROOT%/*}
. $SWMROOT/bin/swmenv
[[ $SECONDS != *.* ]] && exec $SHELL $0 "$@"

(cd $SWMROOT/tmp && (
    find . ! -name . ! -name lost+found -type f -atime +1 -exec rm -f {} \;
    find . ! -name . ! -name lost+found -type l -atime +1 -exec rm -f {} \;
    find . ! -name . ! -name lost+found -type d -mtime +1 -exec rmdir {} \;
)) 2> /dev/null
