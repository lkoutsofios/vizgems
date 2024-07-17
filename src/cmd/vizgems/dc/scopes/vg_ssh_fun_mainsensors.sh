sensors=()
typeset smode sid seenmax
typeset -A sensorsvs sensorsls

function vg_ssh_fun_mainsensors_init {
    sensors.varn=0
    return 0
}

function vg_ssh_fun_mainsensors_term {
    return 0
}

function vg_ssh_fun_mainsensors_add {
    typeset var=${as[var]} inst=${as[inst]}

    typeset -n sensorsr=sensors._${sensors.varn}
    sensorsr.name=$name
    sensorsr.unit=$unit
    sensorsr.type=$type
    sensorsr.var=$var
    sensorsr.inst=$inst
    (( sensors.varn++ ))
    return 0
}

function vg_ssh_fun_mainsensors_send {
    typeset cmd

    cmd="sensors -u 2> /dev/null"
    print -r "$cmd"
    return 0
}

function vg_ssh_fun_mainsensors_receive {
    typeset val=$1

    [[ $val == '' ]] && {
        smode='' sid=''
    }
    [[ $val == Adapter:* ]] && {
        case $val in
        *:*ISA*)  smode=core    ;;
        *:*ACPI*) smode=chassis ;;
        esac
    }
    [[ $smode == chassis && $val == temp+([0-9]):* ]] && {
        sid=${val#temp}
        sid=${sid%:*}
    }
    [[ $smode == core && $val == Core\ +([0-9]):* ]] && {
        sid=${val##Core?( )}
        sid=${sid%:*}
    }
    [[ $val == *temp*_input:* ]] && {
        if [[ $smode != '' && $sid != '' ]] then
            sensorsvs[sensor_stemp.$smode$sid]=${val##*' '}
            sensorsls[sensor_stemp.$smode$sid]="$smode $sid"
        fi
    }
    return 0
}

function vg_ssh_fun_mainsensors_emit {
    typeset sensorsi

    for (( sensorsi = 0; sensorsi < sensors.varn; sensorsi++ )) do
        typeset -n sensorsr=sensors._$sensorsi
        [[ ${sensorsvs[${sensorsr.var}.${sensorsr.inst}]} == '' ]] && continue
        typeset -n vref=vars._$varn
        (( varn++ ))
        vref.rt=STAT
        vref.name=${sensorsr.name}
        vref.type=${sensorsr.type}
        vref.num=${sensorsvs[${sensorsr.var}.${sensorsr.inst}]}
        vref.unit=C
        vref.label="Temp Sensor (${sensorsls[${sensorsr.var}.${sensorsr.inst}]})"
    done
    return 0
}

function vg_ssh_fun_mainsensors_invsend {
    typeset cmd

    cmd="sensors -u 2> /dev/null"
    print -r "$cmd"
    return 0
}

function vg_ssh_fun_mainsensors_invreceive {
    typeset val=$1

    [[ $val == '' ]] && {
        smode='' sid='' seenmax=''
    }
    [[ $val == Adapter:* ]] && {
        case $val in
        *:*ISA*)  smode=core    ;;
        *:*ACPI*) smode=chassis ;;
        esac
    }
    [[ $smode == chassis && $val == temp+([0-9]):* ]] && {
        sid=${val#temp}
        sid=${sid%:*}
    }
    [[ $smode == core && $val == Core\ +([0-9]):* ]] && {
        sid=${val##Core?( )}
        sid=${sid%:*}
    }
    [[ $val == *temp*_input:* ]] && {
        if [[ $smode != '' && $sid != '' ]] then
            print "node|o|$aid|si_stempid$smode$sid|$smode$sid"
        fi
    }
    [[ $val == *temp*_max:* ]] && {
        if [[ $smode != '' && $sid != '' ]] then
            print "node|o|$aid|si_sz_sensor_stemp.$smode$sid|${val##*' '}"
            seenmax=y
        fi
    }
    [[ $val == *temp*_crit:* ]] && {
        if [[ $smode != '' && $sid != '' && $seenmax != y ]] then
            print "node|o|$aid|si_sz_sensor_stemp.$smode$sid|${val##*' '}"
            seenmax=y
        fi
    }
    return 0
}

if [[ $SWIFTWARNLEVEL != "" ]] then
    typeset -ft vg_ssh_fun_mainsensors_init vg_ssh_fun_mainsensors_term
    typeset -ft vg_ssh_fun_mainsensors_add vg_ssh_fun_mainsensors_send
    typeset -ft vg_ssh_fun_mainsensors_receive vg_ssh_fun_mainsensors_emit
    typeset -ft vg_ssh_fun_mainsensors_invsend vg_ssh_fun_mainsensors_invreceive
fi
