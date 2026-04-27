#!/bin/bash
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

d=`date`
/usr/sbin/smartctl --scan-open | while read i; do
    i=${i%%'#'*}
    echo DATE: $d
    echo VIZGEMS1: $i
    /usr/sbin/smartctl -i -A $i
    echo VIZGEMS2: $i
done > /var/log/vgsmartctl.log.tmp \
&& mv /var/log/vgsmartctl.log.tmp /var/log/vgsmartctl.log
