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

tools='iface arp cdp vtp trunk'
for i in $tools; do
    [[ $TOOLS != '' && " $TOOLS " != *' '${i##*/}' '* ]] && continue
    print -u2 running ${i##*/} on $NAME
    $VG_SSCOPESDIR/current/netdisc/vg_nd_snmp_cmd_cisco_$i
done

for i in dot; do
    [[ $TOOLS != '' && " $TOOLS " != *' '${i##*/}' '* ]] && continue
    MODE=loop $VG_SSCOPESDIR/current/netdisc/vg_nd_snmp_cmd_cisco_vtp \
    | while read vid; do
        print -u2 running ${i##*/} for vlan $vid on $NAME
        SNMPARGS="-LE 0 -v 2c -t 5 -c $CS@$vid $SNMPIP" \
        $VG_SSCOPESDIR/current/netdisc/vg_nd_snmp_cmd_cisco_$i
    done
done
