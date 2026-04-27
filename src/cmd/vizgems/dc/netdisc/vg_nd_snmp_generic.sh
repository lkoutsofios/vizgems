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
export SNMPCMD=vgsnmpbulkwalk
export SNMPARGS="-LE 0 -v 2c -t 5 -c $CS $SNMPIP"

tools='iface arp dot'
for i in $tools; do
    [[ $TOOLS != '' && " $TOOLS " != *' '${i##*/}' '* ]] && continue
    print -u2 running ${i##*/} on $NAME
    $VG_SSCOPESDIR/current/netdisc/vg_nd_snmp_cmd_generic_$i
done
