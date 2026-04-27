#!/bin/ksh
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

# wrapper for using scp in scripts while using a password

if [[ $DISPLAY == fake:0 && $SSH_ASKPASS == *vgscp ]] then
    if [[ $SSHPASS == SWMUL*SWMUL ]] then
        pass=${SSHPASS#SWMUL}
        pn=0
        while [[ $pass == *SWMUL ]] do
            ps[$pn]=${pass%%SWMUL*}
            (( pn++ ))
            pass=${pass#*SWMUL}
        done
        pm=0
        [[ -f ssh.lastmulti ]] && pm=$(< ssh.lastmulti)
        pi=$pm
        if [[ -f ssh.prevmulti ]] then
            pi=$(< ssh.prevmulti)
            (( pi++ ))
        fi
        (( pi = pi % pn ))
        print -r -- ${ps[$pi]}
        print -- $pi > ssh.prevmulti
    else
        print $SSHPASS
    fi
    exit 0
fi

if [[ $SSHPASS != '' ]] then
    [[ $DISPLAY != fake:0 && $SSHPASS == SWMUL*SWMUL ]] && rm -f ssh.prevmulti
    export DISPLAY=fake:0 SSH_ASKPASS=vgscp
fi

args=
if [[ $SSHPORT != '' ]] then
    args+=" -p $SSHPORT"
fi
if [[ $SSHKEY != '' ]] then
    args+=" -i $SSHKEY"
fi

VGNEWSESSIONTIMEOUT=240 vgnewsession scp \
    -o ConnectTimeout=${SSHTIMEOUT:-15} -o ServerAliveInterval=15 \
    -o ServerAliveCountMax=2 -o StrictHostKeyChecking=no $args \
"$@"

ret=$?
if [[ $ret == 0 && $SSHPASS == SWMUL*SWMUL && -f ssh.prevmulti ]] then
    mv ssh.prevmulti ssh.lastmulti
fi
exit $ret
