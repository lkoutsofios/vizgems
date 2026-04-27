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

function tn_wait { # $1=timeout $2=string to match
    typeset s

    while read -p -r -t$1 s; do
        [[ $s == $2 ]] && break
    done
}

function tn_drain { # $1=timeout
    typeset s

    while read -p -r -t$1 s; do
        :
    done
}

function tn_read { # $1=timeout $2=variable to use
    typeset -n s=$2

    read -p -r -t$1 s
}

function tn_write { # $1=string to write
    print -p -- "$1"
}
