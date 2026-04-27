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

export cid=$CID aid=$AID ip=$IP user=$USER pass=$PASS cs=$CS
export targettype=$TARGETTYPE scopetype=$SCOPETYPE servicelevel=$SERVICELEVEL
if [[ $ip == *:*:* ]] then
    snmpip=udp6:$ip
else
    snmpip=$ip
fi

set -o pipefail

. vg_units

export INVMODE=y INV_TARGET=$aid
export SNMPCMD=vgsnmpbulkwalk
export SNMPARGS="-v 2c -t 2 -r 2 -c $cs $snmpip"
export SNMPIP=$snmpip

case $targettype in
*infortrend1)
    tools='vg_snmp_cmd_maininfortrend1lun vg_snmp_cmd_maininfortrend1hdd'
    SNMPOID=.1.3.6.1.4.1.1714.1.1.1.11.0
    ;;
*)
    tools='vg_snmp_cmd_maininfortrend2lun vg_snmp_cmd_maininfortrend2hdd'
    SNMPOID=.1.3.6.1.4.1.1714.1.1.1.1.11.0
    ;;
esac

$SNMPCMD $SNMPARGS $SNMPOID | tail -1 | read -r line
line=${line##*'STRING: '}
line=${line//\"/}
[[ $line != '' ]] && print "node|o|$aid|si_sysname|$line"

for tool in $tools; do
    $SHELL $VG_SSCOPESDIR/current/snmp/${tool}
done
