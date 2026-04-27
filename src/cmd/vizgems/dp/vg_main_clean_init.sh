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
function vg_main_clean_init {
    typeset -n gv=$1

    gv.mainspace=16000
    gv.permspace=1000

    gv.cleanlogs=y
    gv.logremovedays=5
    gv.logcatdays=0

    gv.cleanrecs=y
    gv.recremovedays=2

    gv.cleaninc=y
    gv.incremovedays=2

    gv.cleancache=y
    gv.cacheremovedays=1

    gv.level1=y
    gv.level2=n
    gv.level3=n

    typeset +n gv
}
