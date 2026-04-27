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
ntp=()
typeset -A ntpvs

function vg_ssh_fun_mainntp_init {
    ntp.varn=0
    return 0
}

function vg_ssh_fun_mainntp_term {
    return 0
}

function vg_ssh_fun_mainntp_add {
    typeset var=${as[var]} inst=${as[inst]}

    typeset -n ntpr=ntp._${ntp.varn}
    ntpr.name=$name
    ntpr.unit=ms
    ntpr.type=$type
    ntpr.var=$var
    ntpr.inst=$inst
    (( ntp.varn++ ))
    return 0
}

function vg_ssh_fun_mainntp_send {
    typeset cmd

    case $targettype in
    *linux*)
        cmd="(/usr/sbin/ntpq -p || /usr/sbin/ntpdc -c peers || /usr/bin/ntpq -p || /usr/bin/ntpdc -c peers || /usr/bin/chronyc sourcestats || /usr/bin/timedatectl timesync-status) 2> /dev/null"
        ;;
    *freebsd*)
        cmd="/usr/bin/ntpq -p"
        ;;
    esac
    print -r "$cmd"
    return 0
}

function vg_ssh_fun_mainntp_receive {
    typeset vn fs

    [[ $1 == *remote*local* || $1 == *@(LOCAL|POOL|INIT)* || $1 == *Name* || $1 == *Number* || $1 == *====* ]] && return 0
    set -f
    set -A vs -- $1
    set +f
    vn=${#vs[@]}

    if (( vn == 8 )) then
        ntpvs[ntp_offset._total]=${vs[6]%%+([a-z])}
    elif (( vn == 10 )) then
        ntpvs[ntp_offset._total]=${vs[8]}
    elif (( vn == 2 )) && [[ ${vs[0]} == Offset: ]] then
        ntpvs[ntp_offset._total]=${vs[1]}
    fi
    return 0
}

function vg_ssh_fun_mainntp_emit {
    typeset ntpi

    for (( ntpi = 0; ntpi < ntp.varn; ntpi++ )) do
        typeset -n ntpr=ntp._$ntpi
        [[ ${ntpvs[${ntpr.var}.${ntpr.inst}]} == '' ]] && continue
        typeset -n vref=vars._$varn
        (( varn++ ))
        vref.rt=STAT
        vref.name=${ntpr.name}
        vref.type=${ntpr.type}
        vref.num=${ntpvs[${ntpr.var}.${ntpr.inst}]}
        vref.unit=${ntpr.unit}
        vref.label="NTP Offset (All)"
    done
    return 0
}

function vg_ssh_fun_mainntp_invsend {
    return 0
}

function vg_ssh_fun_mainntp_invreceive {
    return 0
}

if [[ $SWIFTWARNLEVEL != "" ]] then
    typeset -ft vg_ssh_fun_mainntp_init vg_ssh_fun_mainntp_term
    typeset -ft vg_ssh_fun_mainntp_add vg_ssh_fun_mainntp_send
    typeset -ft vg_ssh_fun_mainntp_receive vg_ssh_fun_mainntp_emit
    typeset -ft vg_ssh_fun_mainntp_invsend vg_ssh_fun_mainntp_invreceive
fi
