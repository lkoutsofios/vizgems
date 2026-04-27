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

targetname=$1
targetaddr=$2
targettype=$3

IFS='|'
typeset -A names
while read -r name type unit impl; do
    names[$name]=1
done

IFS='&'
set -f
set -A al -- $impl
set +f
unset as; typeset -A as
for a in "${al[@]}"; do
    k=${a%%=*}
    v=${a#*=}
    v=${v//'+'/' '}
    v=${v//@([\'\\])/'\'\1}
    eval "v=\$'${v//'%'@(??)/'\x'\1"'\$'"}'"
    v=${v//%26/'&'}
    as[$k]=$v
done

IFS=$'\t\t'

typeset -A sid2lid sid2pid sidtypes sidlabels sidkinds sidunits
[[ -f ./synap.list ]] && . ./synap.list

typeset -l typeid

today=$(printf '%(%Y-%m-%d 00:00:00)T')

firstline=y
mysql -h $targetaddr -u$EXECUSER -p$EXECPASS --database synap -e \
    "select * from tbl_realtime_data where data_time_stamp >= \"$today\"" \
2> /dev/null \
| while read -r sid data time; do
    [[ $firstline == y ]] && { firstline=n; continue; }
    lid=${sid2lid[$sid]}
    pid=${sid2pid[$sid]}
    type=${sidtypes[$sid]}
    typeid=${type//' '/_}
    label=${sidlabels[$sid]}
    kind=${sidkinds[$sid]}
    unit=${sidunits[$sid]}
    [[ $lid == '' || $pid == '' || $typeid == '' ]] && continue
    [[ $kind == '' || $label == '' ]] && continue
    print "rt=STAT alvids=\"r:synap$pid\" name=sensor_${kind}.${pid}_${typeid} label=\"$label\" num=$data unit=$unit"
done
