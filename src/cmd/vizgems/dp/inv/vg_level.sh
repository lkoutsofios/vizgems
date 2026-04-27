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

if [[ $SWIFTWARNLEVEL != '' ]] then
    set -x
fi

if [[ $CASEINSENSITIVE == y ]] then
    trcmd='tr A-Z a-z'
else
    trcmd=cat
fi

mode=$1
shift

case $mode in
one)
    in=$1
    outn=$2
    outm=$3

    egrep '^node\|' $in | sed 's/^node.//' | $trcmd \
    | ddsload -os vg_level_node.schema -le '|' -type ascii -dec simple \
        -lnts -lso vg_level_node.load.so \
    > $outn.tmp && sdpmv $outn.tmp $outn

    egrep '^map\|' $in | sed 's/^map.//' | $trcmd \
    | ddsload -os vg_level_map.schema -le '|' -type ascii -dec simple \
        -lnts -lso vg_level_map.load.so \
    > $outm.tmp && sdpmv $outm.tmp $outm
    ;;
all)
    suffixn=$1
    suffixm=$2
    shift 2
    outn=$1
    outm=$2

    ddscat -fp "*-$suffixn.dds" \
    | ddssort -fast -u -ke id \
    > $outn.tmp && sdpmv $outn.tmp $outn

    export LEVELNODEFILE=$outn
    ddscat -fp "*-$suffixm.dds" \
    | ddsconv -os vg_level_map.schema -cso vg_level_map.conv.so \
    | ddssort -fast -u -ke 'id1 id2 index' \
    > $outm.tmp && sdpmv $outm.tmp $outm
    ;;
esac
