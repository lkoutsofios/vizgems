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

function suireadkv {
    # $1 = fd $2 = var $3 = optional output prefix
    typeset ifs fd line k v kv

    ifs="$IFS"
    IFS=''
    set -f
    fd=$1
    typeset -n x=$2
    x=()
    typeset +n x

    while read -r -u$fd line; do
        k=${line%%=*}
        v=${line#"$k"=}
        typeset -n x=$2.$k
        x[${#x[@]}]=$v
        if [[ $3 != '' ]] then
            print "$3$k=\"$v\""
        fi
        typeset +n x
    done
    set +f
    IFS="$ifs"
}
