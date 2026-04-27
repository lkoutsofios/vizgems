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

typeset -i n=0
typeset -F03 s=0.0

# dellNetCpuUtil5Min
$SNMPCMD -On $SNMPARGS .1.3.6.1.4.1.6027.3.26.1.4.4.1.5 \
| while read line; do
    if [[ $line == *Gauge* ]] then
        v=${line##*': '}
        v=${v%%' '*}
        (( s += v ))
        (( n++ ))
    fi
done

if (( n > 0 )) then
    (( s = s / n ))
    print "rt=STAT name=cpu_used._total type=number num=$s unit=% label=\"CPU Used (All)\""
fi
