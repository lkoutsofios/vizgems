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

cd $SWMDIR || exit 1

print "<table border>"
for descr in .descr.*; do
    file=${descr#.descr.}
    if [[ -f $file ]] then
        print "<tr>"
        print "<td><a href=$SWMDIR_REL/$file>$file</a></td>"
        print "<td>$(/bin/ls -l $file | awk '{ print $5 }') bytes</td>"
        print "<td>$(< $descr)</td>"
        print "</tr>"
    fi
done
print "</table>"
