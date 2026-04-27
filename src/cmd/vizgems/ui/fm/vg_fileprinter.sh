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

configfile=$1

. $configfile || exit 1

file=$2

typeset -n fdata=files.$file

headersep=${fdata.headersep}
footersep=${fdata.footersep}

if [[ $fdata == '' ]] then
    print -u2 SWIFT ERROR cannot find file info in config
    exit 1
fi

search=$3

if [[ $search == '' ]] then
    search='*'
fi

if [[ $headersep != '' ]] then
    if ! fgrep "$headersep" ${fdata.location} > /dev/null 2>&1; then
        print -u2 SWIFT ERROR header line not present if ${fdata.location}
        exit 1
    fi
fi

if [[ $footersep != '' ]] then
    if ! fgrep "$footersep" ${fdata.location} > /dev/null 2>&1; then
        print -u2 SWIFT ERROR footer line not present if ${fdata.location}
        exit 1
    fi
fi

(
    if [[ $headersep != '' ]] then
        while read -u3 -r line; do
            if [[ $line == *$headersep* ]] then
                break
            fi
        done
    fi

    while read -u3 -r line; do
        if [[ $footersep != '' && $line == *$footersep* ]] then
            break
        fi
        if [[ $line == $search ]] then
            print -r "$line"
        fi
    done

) 3< ${fdata.location}

exit 0
