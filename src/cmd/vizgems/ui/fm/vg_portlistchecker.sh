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

function vg_portlistchecker {
    typeset rest target port timeout aname
    integer errn=0 warnn=0

    if [[ $3 == \#* ]] then
        print -r -- "rec=${3//'|'+'|'/'|'}"
        print WARNING entry is commented out
        print "errors=0\nwarnings=1"
        return 0
    fi

    rest=$3
    target=${rest%%\|+\|*}
    rest=${rest#"$target"\|+\|}
    port=${rest%%\|+\|*}
    rest=${rest#"$port"\|+\|}
    timeout=${rest%%\|+\|*}
    rest=${rest#"$timeout"\|+\|}
    aname=$rest

    if [[ $port != +([0-9]) ]] then
        print ERROR port field must be an integer
        print "errors=1\nwarnings=0"
        return 1
    fi

    if [[ $timeout != +([0-9]) ]] then
        print ERROR timeout field must be an integer
        print "errors=1\nwarnings=0"
        return 1
    fi

    if (( timeout < 1 || timeout > 60 )) then
        print ERROR timeout value must be between 1 - 60
        print "errors=1\nwarnings=0"
        return 1
    fi

    aname="${aname//[ 	]/_}"

    print -r -- "rec=$target $port $timeout $aname"
    print "errors=$errn\nwarnings=$warnn"

    return 0
}
