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
function vg_alarm_inc_init {
    typeset -n gv=$1

    gv.filetype=REG
    gv.filepatincl='*'
    gv.filepatexcl='*.tmp'
    gv.filepatremove=''
    gv.filecheckuse=n
    gv.filesperround=512
    gv.filesinparallel=64
    gv.fileremove=y
    gv.filecollector=vg_alarm_collector
    gv.filesync=n
    gv.filerecord=n

    gv.mainspace=500

    typeset +n gv

    if [[ $ACCEPTOLDINCOMING == '' ]] then
        if [[ -f $VGMAINDIR/dpfiles/config.sh ]] then
            . $VGMAINDIR/dpfiles/config.sh
        fi
        export ACCEPTOLDINCOMING=${ACCEPTOLDINCOMING:-n}
        if [[ $ACCEPTOLDINCOMING == +([0-9]) ]] then
            ACCEPTOLDINCOMING=${ACCEPTOLDINCOMING}d
        fi
    fi
}
