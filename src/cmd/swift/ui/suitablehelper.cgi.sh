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

export SWMROOT=${DOCUMENT_ROOT%/htdocs}
. $SWMROOT/bin/swmenv
[[ $SECONDS != *.* ]] && exec $SHELL $0 "$@"
. $SWMROOT/bin/swmgetinfo

suireadcgikv

if [[
    $qs_instance == '' || $qs_group == '' || $qs_conf == '' || $qs_file == ""
]] then
    print -u2 "ERROR configuration not specified"
    exit 1
fi

. $SWMROOT/proj/$qs_instance/bin/${qs_instance}_env || exit 1

print "Content-type: text/html\n"

url="file=$qs_file"
suitable -instance $qs_instance -group $qs_group \
    -conf ${SWIFTDATADIR}$qs_conf -sortkey "$qs_sortkey" -sorturl "$url" \
< $SWIFTDATADIR/$qs_file
