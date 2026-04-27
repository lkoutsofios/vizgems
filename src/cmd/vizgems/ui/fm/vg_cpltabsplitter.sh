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

function vg_cpltabsplitter {
    typeset rest i f v1 v2 v t

    if [[ $3 == '' ]] then
        print -u2 SWIFT ERROR missing mode
        return 1
    fi

    if [[ $4 == '' ]] then
        print -u2 SWIFT ERROR missing record
        return 1
    fi

    rest=$4
    for (( i = 0; i < 3; i++ )) do
        f=${rest%%:*}
        rest=${rest#"$f":}
        v1="$v1:$f"
        v2="$v2|+|$f"
        t="$t:$f"
    done
    v1=${v1#:}
    v2=${v2#\|+\|}
    t=${t#:}
    v="$v1|++|$v2"

    print -r "<option value='${v//\'/%27}'>$t"

    return 0
}
