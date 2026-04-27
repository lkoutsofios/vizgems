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
file=$2

. vg_hdr

. $configfile || exit 1

if [[ $file != '' ]] then
    flist=$file
else
    flist=
    for i in "${!files.@}"; do
        [[ $i == *.*.* ]] && continue
        flist+=" ${i#*.}"
    done
fi

for file in $flist; do
    typeset -n fdata=files.$file
    if [[ ${fdata.locationmode} != dir ]] then
        # this is not available on uwin ksh yet
        #md5=${ sum -x md5 "${fdata.location}"; }
        md5=$(sum -x md5 "${fdata.location}")
        print "${md5%%' '*}|$file||${fdata.location}"
    else
        for i in ${fdata.location}/*; do
            [[ ! -f $i ]] && continue
            [[ ${i##*/} != ${fdata.locationre:-'*'} ]] && continue
            #md5=${ sum -x md5 "$i"; }
            md5=$(sum -x md5 "$i")
            print "${md5%%' '*}|$file|${i##*/}|$i"
        done
    fi
done

exit 0
