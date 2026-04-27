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
function sdpensuredualdirs { # date, datadir, linkdir
    typeset date=$1
    typeset datadir=$2
    typeset linkdir=$3 # may be empty

    if [[ ! -d $datadir/$date ]] then
        if ! mkdir -p $datadir/$date; then
            print -u2 ERROR cannot create $datadir/$date
            return 1
        fi
        if [[ $linkdir != '' ]] then
            if [[ $linkdir/$date -ef $datadir/$date ]] then
                return 0
            fi
            rm -f $linkdir/$date
            if ! mkdir -p $linkdir/${date%/*}; then
                print -u2 ERROR cannot create $linkdir/${date%/*}
                return 1
            fi
            if ! ln -s $datadir/$date $linkdir/$date; then
                print -u2 ERROR cannot create $linkdir/$date
                return 1
            fi
        fi
    fi
    if [[ ! -d $datadir/$date/input ]] then
        if ! mkdir -p $datadir/$date/input; then
            print -u2 ERROR cannot create $datadir/$date/input
            return 1
        fi
    fi
    if [[ ! -d $datadir/$date/processed ]] then
        if ! mkdir -p $datadir/$date/processed; then
            print -u2 ERROR cannot create $datadir/$date/processed
            return 1
        fi
    fi
    return 0
}
