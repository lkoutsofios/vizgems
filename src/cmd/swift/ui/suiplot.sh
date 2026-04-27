#!/bin/ksh
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

export SHELL=$(which ksh 2> /dev/null)
[[ $SECONDS != *.* ]] && exec $SHELL $0 "$@"

SWIFTPROFILES=${SWIFTPROFILES:-$HOME/.suirc}

if [[ -f $SWIFTPROFILES/all.lefty ]] then
    CMD1="load ('$SWIFTPROFILES/all.lefty');"
fi

if [[ -f $SWIFTPROFILES/$1.lefty ]] then
    CMD2="load ('$SWIFTPROFILES/$1.lefty');"
fi

if [[ -f $7/$8.lefty ]] then
    CMD3="load ('$7/$8.lefty');"
fi

lefty3d -e "
    load ('suiplot.lefty');
    load ('suiutil.lefty');
    suiutil.msglabel = 'SWIFT Plot message: ';
    load ('$1.lefty');
    $CMD1
    $CMD2
    $CMD3
    suiplot.init ($1);
    suiplot.main (
        concat ('/dev/tcp/$2/', '$3'), 'http://$4:$5', '$6', '$7'
    );
    txtview ('off');
"
