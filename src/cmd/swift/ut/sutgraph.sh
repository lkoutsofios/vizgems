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
function sutgraph {
    typeset lt=dot sz=0 tm=60

    while (( $# > 0 )) do
        case $1 in
        -lt)
            lt=$2
            shift 2
            ;;
        -sz)
            sz=$2
            shift 2
            ;;
        -tm)
            tm=$2
            shift 2
            ;;
        *)
            break
            ;;
        esac
    done

    if (( tm > 0 )) then
        { ulimit -t $tm; $lt "$@"; }
    else
        $lt "$@"
    fi
}
