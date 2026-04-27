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

function m2js { # $1 = cmd $2 = args
    print "  delete tmpo"
    print "  var tmpo = new Object ()"
    typeset -A keys
    typeset havech
    typeset -n x=$2

    for i in "${!x.@}"; do
        k=${i#$2.}
        havech=n
        if [[ $k == *.* ]] then
            k=${k%%.*}
            havech=y
        fi
        if [[ ${keys[$k]} != y ]] then
            keys[$k]=$havech
        fi
    done
    for k in "${!keys[@]}"; do
        typeset -n x=$2.$k
        if [[ ${keys[$k]} == y ]] then
            print "  tmpo._$k = new Array ("
            for ((j = 0; ; j++ )) do
                typeset -n y=$2.$k._$j
                if [[ ${y} == '' ]] then
                    break
                fi
                if (( j != 0 )) then
                    print ", \c"
                fi
                print "\"${y}\""
                typeset +n y
            done
            print "  )"
        else
            print "  tmpo._$k = \"$x\""
        fi
        typeset +n x
    done
}

exit 0

SWIFTPROFILES=${SWIFTPROFILES:-$HOME/.suirc}

instance=$1
mserver=$2
mport=$3
dserver=$4
dport=$5
prefprefix=$6

tmpfile=${TMPDIR:-/tmp}/suibrowser.$USER.$$
trap 'rm -f $tmpfile' HUP QUIT TERM KILL EXIT

suiencode | { read is; read os; }
exec 3<> /dev/tcp/$2/$3
print -u3 ASWIFTMSERVER
read -u3 ret
[[ $ret == YES ]] || exit 1
print -u3 $is
print -u3 $os
read -u3 ret
[[ $ret == YES ]] || exit 1
print -u3 primaryoff

print -u3 begin
print -u3 cmd=history
print -u3 end

#for ((i = 0; i < 30; i++)) do
#    xwininfo -root -tree | egrep "$SWIFTINSTANCENAME User Interface" \
#    | read id rest
#    if [[ $id != '' ]] then
#        break
#    fi
#done
#xwininfo -root -tree | egrep "$SWIFTINSTANCENAME User Interface" \
#| read id rest
case $id in
?*) nargs="-id $id -noraise" ;;
*) nargs="-noraise"
esac
(
    print "<html><body><script>"
    print "</script></body></html>"
) > $tmpfile
netscape $nargs -remote "openURL (file://$tmpfile, ${instance}_res)"

while suireadcmd 3 cmd args; do
    case $cmd in
    load)
        (
            print "<html><body><script>"
            m2js cmd args
            print "  parent.frames[0].suipad_insert (tmpo)"
            print "</script></body></html>"
        ) > $tmpfile
        netscape $nargs -remote "openURL (file://$tmpfile, ${instance}_res)"
        ;;
    unload)
        (
            print "<html><body><script>"
            m2js cmd args
            print "  parent.frames[0].suipad_remove (tmpo)"
            print "</script></body></html>"
        ) > $tmpfile
        netscape $nargs -remote "openURL (file://$tmpfile, ${instance}_res)"
        ;;
    reload)
        (
            print "<html><body><script>"
            m2js cmd args
            print "  parent.frames[0].suipad_reloadmany (tmpo)"
            print "</script></body></html>"
        ) > $tmpfile
        netscape $nargs -remote "openURL (file://$tmpfile, ${instance}_res)"
        ;;
    focus)
        (
            print "<html><body><script>"
            m2js cmd args
            print "  parent.frames[0].suipad_focus (tmpo)"
            print "</script></body></html>"
        ) > $tmpfile
        netscape $nargs -remote "openURL (file://$tmpfile, ${instance}_res)"
        ;;
    select)
        (
            print "<html><body><script>"
            m2js cmd args
            print "  parent.frames[0].suipad_selection (tmpo)"
            print "</script></body></html>"
        ) > $tmpfile
        netscape $nargs -remote "openURL (file://$tmpfile, ${instance}_res)"
        ;;
    esac
    unset ${!args.@} args
done
