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

vg_ecvals=
vg_ecn2is=
typeset -lF3 vg_ecresult=

function vg_expr_calc_var { # $1: variable name
    typeset name=$1
    typeset -n ecn2is=$vg_ecn2is

    typeset -n ecvref=${vg_ecvals}[${ecn2is[${name}]:-_}]
    if [[ ${ecvref} == '' ]] then
        print -u2 vg_expr_calc_var: cannot find variable $name
        return 1
    fi
    [[ ${ecvref.nodata} != '' ]] && return 1
    if [[ ${ecvref.rti} != '' ]] then
        typeset -n vr=ecvref.num_${ecvref.rti}
        print -r -- $vr
    else
        print -r -- ${ecvref.num}
    fi
    return 0
}

function vg_expr_calc { # $1: var ref, $2: var map, $3: expression
    vg_ecvals=$1
    vg_ecn2is=$2
    typeset val=$3 var v

    while [[ $val == *{*}* ]] do
        var=${val#*'{'}
        var=${var%%'}'*}
        v=$(vg_expr_calc_var $var) || return 1
        val=${val//"{$var}"/${v}}
    done
    vg_ecresult=$(( $val ))
    return 0
}
