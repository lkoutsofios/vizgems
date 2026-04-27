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

configfile=$1
file=$2
efile=$3

. vg_hdr

. $configfile || exit 1

export DOCUMENT_ROOT=$VG_DWWWDIR/htdocs

typeset -n fdata=files.$file

if [[ ${fdata.name} == '' ]] then
    print -u2 ERROR cannot find file info in config
    exit 1
fi

ifs="$IFS"
IFS=';'
while read -r op id pass groups name info; do
    if [[ $op == '<u>'*'</u>' ]] then
        print -u5 "${op//@('<u>'|'</u>')/}"
        continue
    fi
    [[ $op != @(add|mod|del) ]] && continue
    swmaccounts "$op" "$id" "$pass" "$groups" "$name" "$info" || break
done < $efile
IFS="$ifs"

exit 0
