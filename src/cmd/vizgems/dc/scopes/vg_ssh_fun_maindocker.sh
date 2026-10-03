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
docker=()
typeset -A dockervs dockerls dockerus

function vg_ssh_fun_maindocker_init {
    docker.varn=0
    return 0
}

function vg_ssh_fun_maindocker_term {
    return 0
}

function vg_ssh_fun_maindocker_add {
    typeset var=${as[var]} inst=${as[inst]}

    typeset -n dockerr=docker._${docker.varn}
    dockerr.name=$name
    dockerr.unit=$unit
    dockerr.type=$type
    dockerr.var=$var
    dockerr.inst=$inst
    (( docker.varn++ ))
    return 0
}

function vg_ssh_fun_maindocker_send {
    print -r "docker stats --no-stream --format \"{{.ID}}|{{.Name}}|{{.CPUPerc}}|{{.MemUsage}}|{{.MemPerc}}|{{.NetIO}}|{{.BlockIO}}|{{.PIDs}}\""
    return 0
}

function vg_ssh_fun_maindocker_receive {
    typeset ifs vn di mem net u v

    ifs="$IFS"
    IFS='|'
    set -f
    set -A vs -- $1
    set +f
    vn=${#vs[@]}

    di=$(print "${vs[1]}" | sum -x md5)

    dockervs[drcpu_used.$di]=${vs[2]%'%'}
    dockerls[drcpu_used.$di]="Docker CPU Used (${vs[1]})"
    dockerus[drcpu_used.$di]='%'

    mem=${vs[3]}
    mem=${mem%%' '*}
    u=${mem##+([0-9.])}
    v=${mem%%"$u"}
    u=${u//i/}
    vg_unitconv "$v" $u GB
    val=$vg_ucnum
    if [[ $val != '' ]] then
        dockervs[drmemory_used.$di]=$val
        dockerls[drmemory_used.$di]="Docker Used Memory (${vs[1]})"
        dockerus[drmemory_used.$di]='GB'
    fi

    net=${vs[5]}
    net=${net%%' '*}
    u=${net##+([0-9.])}
    v=${net%%"$u"}
    u=${u//i/}
    vg_unitconv "$v" $u MB
    val=$vg_ucnum
    if [[ $val != '' ]] then
        dockervs[drtcpip_inbyte.$di]=$val
        dockerls[drtcpip_inbyte.$di]="Docker In Byte (${vs[1]})"
        dockerus[drtcpip_inbyte.$di]='MB'
    fi

    net=${vs[5]}
    net=${net##*' '}
    u=${net##+([0-9.])}
    v=${net%%"$u"}
    u=${u//i/}
    vg_unitconv "$v" $u MB
    val=$vg_ucnum
    if [[ $val != '' ]] then
        dockervs[drtcpip_outbyte.$di]=$val
        dockerls[drtcpip_outbyte.$di]="Docker Out Byte (${vs[1]})"
        dockerus[drtcpip_outbyte.$di]='MB'
    fi
    IFS="$ifs"
    return 0
}

function vg_ssh_fun_maindocker_emit {
    typeset dockeri

    for (( dockeri = 0; dockeri < docker.varn; dockeri++ )) do
        typeset -n dockerr=docker._$dockeri
        [[ ${dockervs[${dockerr.var}.${dockerr.inst}]} == '' ]] && continue
        typeset -n vref=vars._$varn
        (( varn++ ))
        vref.rt=STAT
        vref.name=${dockerr.name}
        vref.type=${dockerr.type}
        vref.num=${dockervs[${dockerr.var}.${dockerr.inst}]}
        vref.unit=${dockerus[${dockerr.var}.${dockerr.inst}]}
        vref.label=${dockerls[${dockerr.var}.${dockerr.inst}]}
    done
    return 0
}

function vg_ssh_fun_maindocker_invsend {
    print -r "docker stats --no-stream --format \"{{.ID}}|{{.Name}}|{{.CPUPerc}}|{{.MemUsage}}|{{.MemPerc}}|{{.NetIO}}|{{.BlockIO}}|{{.PIDs}}\""
    return 0
}

function vg_ssh_fun_maindocker_invreceive {
    typeset ifs vn fs val di mem u v

    ifs="$IFS"
    IFS='|'
    set -f
    set -A vs -- $1
    set +f
    vn=${#vs[@]}

    di=$(print "${vs[1]}" | sum -x md5)

    print "node|o|$aid|si_dockerid$di|${vs[1]}"

    mem=${vs[3]}
    mem=${mem##*' '}
    u=${mem##+([0-9.])}
    v=${mem%%"$u"}
    u=${u//i/}
    vg_unitconv "$v" $u GB
    val=$vg_ucnum
    if [[ $val != '' ]] then
        print "node|o|$aid|si_sz_drmemory_used.$di|$val"
    fi
    IFS="$ifs"
    return 0
}

if [[ $SWIFTWARNLEVEL != "" ]] then
    typeset -ft vg_ssh_fun_maindocker_init vg_ssh_fun_maindocker_term
    typeset -ft vg_ssh_fun_maindocker_add vg_ssh_fun_maindocker_send
    typeset -ft vg_ssh_fun_maindocker_receive vg_ssh_fun_maindocker_emit
    typeset -ft vg_ssh_fun_maindocker_invsend vg_ssh_fun_maindocker_invreceive
fi
