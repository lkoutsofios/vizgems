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
function vg_stat_inc_fileinfo {
    typeset -n gv=$1
    typeset -n ov=$2
    typeset inname=$3

    typeset time date rest undo t1 t2

    case $inname in
    stats.[0-9]*.xml)
        tim=${inname#stats.}
        tim=${tim%.xml}
        ov.date=${tim:0:10}
        ov.outname=${tim:11}.stats.xml
        ;;
    pd.*-[0-9]*-[0-9]*)
        time=${inname##*-}
        rest=${inname%-"$time"}
        date=${rest##*-}
        rest=${rest%-"$date"}
        id=${rest#*.}
        ov.date=${date:4:4}.${date:0:2}.${date:2:2}
        ov.outname=$time.$id.stats.txt
        ;;
    esac

    if [[ -f $VGMAINDIR/data/main/${ov.date//.//}/complete.stamp ]] then
        undo=n
        t1=${ printf '%(%#)T' "${ov.date}-00:00:00"; }
        t2=${ printf '%(%#)T'; }
        if [[ $ACCEPTOLDINCOMING == +([0-9])d ]] then
            if (( t2 - t1 < ${ACCEPTOLDINCOMING%d} * 24 * 60 * 60 )) then
                undo=y
            fi
        elif [[ $ACCEPTOLDINCOMING == +([0-9])h ]] then
            if (( t2 - t1 < ${ACCEPTOLDINCOMING%h} * 60 * 60 )) then
                undo=y
            fi
        fi
        if [[ $undo == y ]] then
            touch $VGMAINDIR/data/main/${ov.date//.//}/notcomplete.stamp
            rm -f $VGMAINDIR/data/main/${ov.date//.//}/complete.stamp*
            rm -f $VGMAINDIR/data/main/${ov.date//.//}/../complete.stamp*
            rm -f $VGMAINDIR/data/main/${ov.date//.//}/../../complete.stamp*
        fi
    fi

    typeset +n gv
    typeset +n ov
}
