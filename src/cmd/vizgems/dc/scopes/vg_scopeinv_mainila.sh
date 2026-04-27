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

export cid=$CID aid=$AID ip=$IP user=$USER pass=$PASS cs=$CS
export targettype=$TARGETTYPE scopetype=$SCOPETYPE servicelevel=$SERVICELEVEL

set -o pipefail

. vg_units

export SSHPASS=$pass
unset SSHKEY
if [[ $pass == sshkey=* ]] then
     print -- "${pass#*=}" > ssh.key
     chmod 600 ssh.key
     export SSHKEY=./ssh.key
     unset SSHPASS
fi

if [[ $1 == *dir=* ]] then
    dir=${1##*dir=}; dir=${dir%%'&'*}
else
    dir=vg
fi

> got.inventory

for (( i = 0; i < 2; i++ )) do
    if vgscp $user@$ip:$dir/inventory ila_inventory.txt; then
        if vgscp got.inventory $user@$ip:$dir/got.inventory; then
            break
        fi
    else
        > ila_inventory.txt
    fi
done >> ssh.err 2>&1

while read -r line; do
    line=${line//_ASSET_/$aid}
    if [[ $line != *'|aid='* ]] then
        line+="|aid=$aid"
    fi
    if [[ $line != *'|cid='* ]] then
        line+="|cid=$cid"
    fi
    print -r "$line"
done < ila_inventory.txt
