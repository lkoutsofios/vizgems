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

tools='maincollectd'

export SSHPASS=$pass
unset SSHKEY
if [[ $pass == sshkey=* ]] then
    print -- "${pass#*=}" > ssh.key
    chmod 600 ssh.key
    export SSHKEY=./ssh.key
    unset SSHPASS
fi

if [[ $1 == *socket=* ]] then
    socket=${1##*socket=}; socket=${socket%%'&'*}
else
    socket=
fi
export COLLECTD_SOCKET=$socket
if [[ $1 == *host=* ]] then
    host=${1##*host=}; host=${host%%'&'*}
else
    host=$aid
fi
export COLLECTD_HOST=$host

for tool in $tools; do
    . $VG_SSCOPESDIR/current/ssh/vg_ssh_fun_${tool}
    vg_ssh_fun_${tool}_init
done
for tool in $tools; do
    vg_ssh_fun_${tool}_invsend | sed "s!\$! | sed 's/^/A${tool}Z/'!"
done | vgssh $user@$ip 2> /dev/null | while read -r line; do
    [[ $line != A*Z* ]] && continue
    tool=${line%%Z*}
    tool=${tool#A}
    rest=${line##A"$tool"Z}
    vg_ssh_fun_${tool}_invreceive "$rest"
done
