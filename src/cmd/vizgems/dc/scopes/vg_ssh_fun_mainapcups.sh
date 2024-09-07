apcups=()
typeset smode sid seenmax
typeset -A apcupsvs apcupsls apcupsus

function vg_ssh_fun_mainapcups_init {
    apcups.varn=0
    return 0
}

function vg_ssh_fun_mainapcups_term {
    return 0
}

function vg_ssh_fun_mainapcups_add {
    typeset var=${as[var]} inst=${as[inst]}

    typeset -n apcupsr=apcups._${apcups.varn}
    apcupsr.name=$name
    apcupsr.unit=$unit
    apcupsr.type=$type
    apcupsr.var=$var
    apcupsr.inst=$inst
    (( apcups.varn++ ))
    return 0
}

function vg_ssh_fun_mainapcups_send {
    typeset cmd

    cmd="apcaccess 2> /dev/null"
    print -r "$cmd"
    return 0
}

function vg_ssh_fun_mainapcups_receive {
    typeset val=$1

    typeset v

    [[ $val == STATUS* ]] && {
        v=0
        [[ $val == *ONLINE ]] && v=100
        apcupsvs[apcups_status._total]=$v
        apcupsls[apcups_status._total]="APC Status (All)"
        apcupsus[apcups_status._total]="%"
    }
    [[ $val == LOADPCT* ]] && {
        v=${val%' '*}
        v=${v##*' '}
        apcupsvs[apcups_load._total]=$v
        apcupsls[apcups_load._total]="APC Load (All)"
        apcupsus[apcups_load._total]="%"
    }
    [[ $val == BCHARGE* ]] && {
        v=${val%' '*}
        v=${v##*' '}
        apcupsvs[apcups_battleft._total]=$v
        apcupsls[apcups_battleft._total]="APC Battery Left (All)"
        apcupsus[apcups_battleft._total]="%"
    }
    [[ $val == TIMELEFT* ]] && {
        v=${val%' '*}
        v=${v##*' '}
        apcupsvs[apcups_timeleft._total]=$v
        apcupsls[apcups_timeleft._total]="APC Time Left (All)"
        apcupsus[apcups_timeleft._total]="m"
    }
    return 0
}

function vg_ssh_fun_mainapcups_emit {
    typeset apcupsi

    for (( apcupsi = 0; apcupsi < apcups.varn; apcupsi++ )) do
        typeset -n apcupsr=apcups._$apcupsi
        [[ ${apcupsvs[${apcupsr.var}.${apcupsr.inst}]} == '' ]] && continue
        typeset -n vref=vars._$varn
        (( varn++ ))
        vref.rt=STAT
        vref.name=${apcupsr.name}
        vref.type=${apcupsr.type}
        vref.num=${apcupsvs[${apcupsr.var}.${apcupsr.inst}]}
        vref.unit=${apcupsus[${apcupsr.var}.${apcupsr.inst}]}
        vref.label=${apcupsls[${apcupsr.var}.${apcupsr.inst}]}
    done
    return 0
}

function vg_ssh_fun_mainapcups_invsend {
    typeset cmd

    cmd="apcaccess 2> /dev/null"
    print -r "$cmd"
    return 0
}

function vg_ssh_fun_mainapcups_invreceive {
    typeset val=$1

    [[ $val == STATUS* ]] && {
        print "node|o|$aid|si_apcupsid_total|_total"
    }
    return 0
}

if [[ $SWIFTWARNLEVEL != "" ]] then
    typeset -ft vg_ssh_fun_mainapcups_init vg_ssh_fun_mainapcups_term
    typeset -ft vg_ssh_fun_mainapcups_add vg_ssh_fun_mainapcups_send
    typeset -ft vg_ssh_fun_mainapcups_receive vg_ssh_fun_mainapcups_emit
    typeset -ft vg_ssh_fun_mainapcups_invsend vg_ssh_fun_mainapcups_invreceive
fi
