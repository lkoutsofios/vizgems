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
function vg_dserverhelper_run {
    typeset -n gv=$1
    typeset name=$2
    typeset -n params=$3

    typeset prefprefix outfile outdir view0 view0file vid cname

    if [[ ${params.query} != '' ]] then
        prefprefix=${params.prefprefix}
        case ${params.query} in
        dataquery)
            outfile=rep.out
            cname=/data/main/$SWMID/${name##*/}
            if ! createcache gv "$cname" params; then
                gv.outfile=${gv.outdir}/$outfile
                return 0
            else
                cd ${gv.outdir} || exit 1
                (
                    $SHELL vg_dq_run < vars.lst > $outfile
                ) 9>&1
                gv.outfile=$PWD/$outfile
            fi
            ;;
        filterquery)
            outfile=rep.out
            cname=/data/main/$SWMID/${name##*/}
            if ! createcache gv "$cname" params; then
                gv.outfile=${gv.outdir}/$outfile
                return 0
            else
                cd ${gv.outdir} || exit 1
                (
                    $SHELL vg_filter_run < vars.lst > $outfile
                ) 9>&1
                gv.outfile=$PWD/$outfile
            fi
            ;;
        wusagequery)
            outfile=rep.out
            cname=/data/main/$SWMID/${name##*/}
            if ! createcache gv "$cname" params; then
                gv.outfile=${gv.outdir}/$outfile
                return 0
            else
                cd ${gv.outdir} || exit 1
                (
                    $SHELL vg_wusage_run < vars.lst > $outfile
                ) 9>&1
                gv.outfile=$PWD/$outfile
            fi
            ;;
        *)
            ;;
        esac
    else
        return 0
    fi
    return 0
}
