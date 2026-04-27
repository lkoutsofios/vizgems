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
function vg_cntl_init { # $1 = gvars
    typeset -n gv=$1

    gv.files="
        inc.inv
        inc.alarm
        inc.stat
        inc.generic
        inc.cm
        proc.inv
        proc.alarm
        proc.alarm2
        proc.alarm3
        proc.stat
        proc.stat2
        proc.stat3
        proc.generic
        proc.generic2
        proc.generic3
        proc.cm
        prop.group1 prop.group2 prop.all
        compl.main
        clean.main
    "

    typeset +n gv
}
