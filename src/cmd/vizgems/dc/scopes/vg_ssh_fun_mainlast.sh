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
last=(
    name='' unit='' type='' var='' inst='' excludere='' pts= nts=
    typeset -A alarms
)
typeset -A lastvs lastus

function vg_ssh_fun_mainlast_init {
    if [[ -f ./last.ts ]] then
        last.pts=$(< ./last.ts)
    else
        last.pts=$(printf '%(%#)T')
        (( last.pts -= 365 * 24 * 60 * 60 ))
    fi
    last.nts=$(printf '%(%#)T')
    return 0
}

function vg_ssh_fun_mainlast_term {
    return 0
}

function vg_ssh_fun_mainlast_add {
    typeset var=${as[var]} inst=${as[inst]} exclude=${as[exclude]}

    last.name=$name
    last.unit=$unit
    last.type=$type
    last.var=$var
    last.inst=$inst
    last.excludere="|${exclude//,/'|'}"
    last.excludere=${last.excludere#'|'}
    last.excludere=${last.excludere%'|'}
    return 0
}

function vg_ssh_fun_mainlast_send {
    print "last -s \"$(printf '%(%Y%m%d%H%M%S)T' \#$(( last.pts - 300 )) )\""
    return 0
}

function vg_ssh_fun_mainlast_receive {
    typeset state sev temp unit

    if [[ $1 == wtmp*begins* || $1 == "" ]] then
        return 0
    fi

    set -A vs -- $1
    usr=${vs[0]%%[ 	]*}
    if [[ $usr != '' && $usr != @(reboot|${last.excludere}) ]] then
        last.alarms[${#last.alarms[@]}]=(
            type=ALARM sev=1 tech='LAST' alarmid='Intrusion'
            txt="Security-Unauthorised User: $1"
        )
    fi
    return 0
}

function vg_ssh_fun_mainlast_emit {
    typeset lasti

    typeset -n vref=vars._$varn
    (( varn++ ))
    vref.rt=STAT
    vref.name=${last.name}
    vref.type=number
    vref.num=1
    vref.unit=

    for (( alarmi = 0; alarmi < ${#last.alarms[@]}; alarmi++ )) do
        typeset -n alarmr=last.alarms[$alarmi]
        typeset -n vref=vars._$varn
        (( varn++ ))
        vref.rt=ALARM
        vref.alarmid=${alarmr.alarmid}
        vref.type=${alarmr.type}
        vref.sev=${alarmr.sev}
        vref.tech=${alarmr.tech}
        vref.tmode=${alarmr.tmode}
        vref.txt=${alarmr.txt}
    done

    print "${last.nts}" > ./last.ts
    return 0
}

function vg_ssh_fun_mainlast_invsend {
    return 0
}

function vg_ssh_fun_mainlast_invreceive {
    return 0
}

if [[ $SWIFTWARNLEVEL != "" ]] then
    typeset -ft vg_ssh_fun_mainlast_init vg_ssh_fun_mainlast_term
    typeset -ft vg_ssh_fun_mainlast_add vg_ssh_fun_mainlast_send
    typeset -ft vg_ssh_fun_mainlast_receive vg_ssh_fun_mainlast_emit
    typeset -ft vg_ssh_fun_mainlast_invsend vg_ssh_fun_mainlast_invreceive
fi
