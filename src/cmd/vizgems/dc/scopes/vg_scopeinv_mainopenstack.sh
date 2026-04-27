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

export INVMODE=y

tools=vg_exec_cmd_mainopenstack

urlbase=http://$IP
if [[ $1 == *urlbase=?* ]] then
    urlbase=${1#*urlbase=}
    urlbase=${urlbase%%'&'*}
fi

bizid=
if [[ $1 == *bizid=?* ]] then
    bizid=${1#*bizid=}
    bizid=${bizid%%'&'*}
fi

locid=
if [[ $1 == *locid=?* ]] then
    locid=${1#*locid=}
    locid=${locid%%'&'*}
fi

authversion=3
if [[ $1 == *authversion=?* ]] then
    authversion=${1#*authversion=}
    authversion=${authversion%%'&'*}
fi

domain=default
if [[ $1 == *domain=?* ]] then
    domain=${1#*domain=}
    domain=${domain%%'&'*}
fi

cat > inv.txt <<#EOF
projectinv|number||EXEC:openstack?projid=$CID&bizid=$bizid&locid=$locid&authversion=$authversion&domain=$domain&urlbase=$urlbase
EOF

for tool in $tools; do
    EXECUSER=$USER EXECPASS=$PASS $SHELL $VG_SSCOPESDIR/current/exec/${tool} \
        $aid $ip $TARGETTYPE \
    < inv.txt
done
