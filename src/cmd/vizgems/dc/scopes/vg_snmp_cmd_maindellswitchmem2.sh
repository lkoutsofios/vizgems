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

typeset -A ms
typeset -i n=0
typeset -F03 s=0.0

# dellNetProcessorMemSize
$SNMPCMD -On $SNMPARGS .1.3.6.1.4.1.6027.3.26.1.4.3.1.6 \
| while read line; do
    if [[ $line == *INTEGER:* ]] then
        i=${line%%' '*}
        i=${i#.1.3.6.1.4.1.6027.3.26.1.4.3.1.6}
        v=${line##*'INTEGER: '}
        ms[$i]=$v
        (( s += v ))
        (( n++ ))
    fi
done

if [[ $INVMODE == y ]] then
    if (( n > 0 )) then
        . vg_units
        vg_unitconv "$s" KB MB
        s=$vg_ucnum
        print "node|o|$AID|si_sz_memory_used._total|$s"
    fi
    return 0
fi

s=0.0
n=0
# dellNetCpuUtilMemUsage
$SNMPCMD -On $SNMPARGS .1.3.6.1.4.1.6027.3.26.1.4.4.1.6 \
| while read line; do
    if [[ $line == *Gauge* ]] then
        i=${line%%' '*}
        i=${i#.1.3.6.1.4.1.6027.3.26.1.4.4.1.6}
        v=${line##*': '}
        v=${v%%' '*}
        if [[ ${ms[$i]} != '' ]] then
            (( s += (ms[$i] * v / 100.0) ))
            (( n++ ))
        fi
    fi
done

if (( n > 0 )) then
    print "rt=STAT name=memory_used._total type=number num=$s unit=KB label=\"Used Memory\""
fi
