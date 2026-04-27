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
function strensuredirs { # [-c] dir1, ...
    typeset cflag i

    if [[ $1 == -c ]] then
        cflag=1
        shift
    fi
    for i in "$@"; do
        if [[ ! -d $i ]] then
            if [[ $cflag == 1 ]] then
                mkdir -p $i
                if [[ ! -d $i ]] then
                    print -u2 ERROR cannot create $i
                    return 1
                fi
            else
                print -u2 ERROR $i does not exist
                return 1
            fi
        fi
    done
    return 0
}
