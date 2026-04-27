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
if [[ ! -f compress.done ]] then
    for i in "$@"; do
        [[ ! -f $i ]] && continue
        [[ -L $i ]] && continue
        ddsinfo -q $i | egrep compression | read a b
        [[ $b == '' || $b != none ]] && continue
        print compressing $i
        if ddscat -ozm rtb $i > $i.new; then
            onrec=$(ddsinfo $i | egrep nrecs:)
            onrec=${onrec##*' '}
            nnrec=$(ddsinfo $i.new | egrep nrecs:)
            nnrec=${nnrec##*' '}
            if [[ $onrec == $nnrec ]] then
                touch -r $i $i.new
                mv $i.new $i
            else
                print ERROR compression failed for $i
                rm -f $i.new
            fi
        else
            print ERROR compression failed for $i
            rm -f $i.new
        fi
    done
fi
touch compress.done
