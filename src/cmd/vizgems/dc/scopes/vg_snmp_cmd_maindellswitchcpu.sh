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

$SNMPCMD -On $SNMPARGS .1.3.6.1.4.1.674.10895.5000.2.6132.1.1.1.1.4.9.0 \
| read line # agentSwitchCpuProcessTotalUtilization

if [[ $line == *300' Secs'* ]] then
    n=${line##*'300 Secs ('*(' ')}
    n=${n%%'%'*}
    print "rt=STAT name=cpu_used._total type=number num=$n unit=% label=\"CPU Used (All)\""
fi
