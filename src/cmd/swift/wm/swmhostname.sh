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

if [[ $SWMADDRMAPFUNC != '' ]] then
    $SWMADDRMAPFUNC
    exit
fi

if [[ $SERVER_NAME != "" ]] then
    print $SERVER_NAME
    exit
fi

if [[ $SERVER_ADDR != "" ]] then
    print $SERVER_ADDR
    exit
fi

name=$(hostname)
if [[ $name == *.* ]] then
    print $name
    exit
fi

ip=$(nslookup -retry=4 -timeout=15 $name | egrep 'Name:|Address:' | tail -2)
if [[ $ip != Name* ]] then
    exit 1
fi

ip=${ip##*\ }
print $ip
