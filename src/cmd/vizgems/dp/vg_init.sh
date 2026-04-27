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
function vg_init { # gvars
    typeset -n gv=$1

    gv.maindir=${VGMAINDIR:-UNSET}
    gv.permdir=${VGPERMDIR}
    gv.mindate=2000.01.01
    gv.maxdate=9999.12.31
    gv.mainspace=1000
    gv.permspace=1000

    gv.datadir=main
    case $2 in
    inv)
        gv.feeddir=inv
        ;;
    alarm)
        gv.feeddir=alarm
        ;;
    stat)
        gv.feeddir=stat
        ;;
    generic)
        gv.feeddir=generic
        ;;
    main)
        gv.feeddir='@(inv|alarm|stat|autoinv|cm|health)'
        ;;
    cm)
        gv.feeddir=cm
        gv.datadir=cm
        gv.mindate=0000.00.00
        gv.maxdate=0000.00.00
        gv.cmfileremovedays=7
        ;;
    esac

    typeset +n gv
}
