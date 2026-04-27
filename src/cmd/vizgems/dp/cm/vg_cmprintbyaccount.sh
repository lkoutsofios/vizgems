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

typeset -A counts

for file in $flist; do
    typeset -n fdata=files.$file
    accountfield=
    for (( i = 0; ; i++ )) do
        typeset -n field=files.$file.fields.field$i
        [[ $field == '' ]] && break
        if [[ ${field.name} == account ]] then
            accountfield=$i
            break
        fi
    done
    [[ $accountfield == '' ]] && continue
    if [[ ${fdata.locationmode} != dir ]] then
        $SHELL ${fdata.fileprint} $configfile $file '' def \
        | while read -r line; do
            id=${line#*"<f>$accountfield|"}
            id=${id%%'<'*}
            (( counts[$file:$id]++ ))
        done
    else
        for i in ${fdata.location}/*; do
            [[ ! -f $i ]] && continue
            [[ ${i##*/} != ${fdata.locationre:-'*'} ]] && continue
            $SHELL ${fdata.fileprint} $configfile $file "${i##*/}" def \
            | while read -r line; do
                id=${line#*"<f>$accountfield|"}
                id=${id%%'<'*}
                (( counts[$file:$id]++ ))
            done
        done
    fi
done

for fileid in "${!counts[@]}"; do
    print "${fileid#*:}|${fileid%%:*}|${counts[$fileid]}"
done

exit 0
