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

if [[ $SWIFTWARNLEVEL != '' ]] then
    set -x
fi

if [[ $CASEINSENSITIVE == y ]] then
    trcmd='tr A-Z a-z'
else
    trcmd=cat
fi

egrep -v '^#|^ *$' $1 | $trcmd \
| ddsload -os vg_trans.schema -le '	' -type ascii -dec simple \
    -lnts -lso vg_trans.load.so \
| ddssort -fast -u -ke inid \
> $2.tmp && sdpmv $2.tmp $2
ddssort -fast -ke outid $2 \
> $3.tmp && sdpmv $3.tmp $3
