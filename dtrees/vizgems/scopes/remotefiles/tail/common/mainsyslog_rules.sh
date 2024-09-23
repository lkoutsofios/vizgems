rules=(
    [syslog]=(
        sev=4
        tmode=keep
        counted=y
        [exclude]=(
            [0]=(
                tool=kernel
                txt='*@(vhci_hcd|ALSA|apparmor|AppArmor|IPVS: Creat|Modules linked|\[<*>\]*0x|audit*callbacks|Read?[0-9]|USB|Touch|usb|MTP|Memory cgroup stats for|node*:slabs:*,objs:*,free:|cache*object*size|entrypoint.sh|audit*cron|veth|Bluetooth)*'
            )
            [1]=(
                tool='systemd*'
                txt='*@([Ss]ession|Reloaded|Start|Stop|Created|Succeeded|slice|seat|buttons|target|Received SIGRTMIN|tmp|Temp|Service hold-off time over|Service hold-off time over|GnuPG|D-Bus|service*Killing|user|dbus|snapper|Sound|pulse|Multimedia|debconf|XDG|xdg|gnome|watcher*does not exist|One time sync config|Finished Create|snap|Bluetooth|journal|successful|PipeWire|tracker-miner|Tracker|gcr-ssh|wireplumber|p11-kit)*'
            )
            [2]=(
                tool='sshd*'
                txt='*@(opened|closed|Accepted|[Dd]isconnected|locate|stashed|kwallet5|deprecated reading of user environment|executable specified in Exec= does not exist)*'
            )
            [3]=( tool='cron*' txt='*@(RunAsUser*ignored|CMD|REPLACE|opened|closed| info |pam_kwallet5)*' )
            [4]=( tool='@(tls_prune|cyr_expire|master|ctl_cyrusdb)' txt='*' )
            [5]=( tool='dnsmasq*' txt='*' )
            [6]=( tool='ovs*' txt='*INFO*' )
            [7]=( tool='snmptrapd' txt='*' )
            [8]=( tool=ntpd txt='*' )
            [9]=( tool='gdm*' txt='*' )
            [10]=( tool='os-prober' txt='*debug:*' )
            [11]=( tool=hp-upgrade txt='*' )
            [12]=( tool='dbus*' txt='*' )
            [13]=( tool='org.freedesktop*' txt='*' )
            [14]=( tool='org.a11y*' txt='*' )
            [15]=( tool=su txt='*cyrus*' )
            [16]=( tool=irqbalance txt='*affinity_hint subset empty*' )
            [17]=( tool=sqlanywhere txt='*' )
            [18]=( tool='*' txt='*SELinux*' )
            [19]=( tool='setroubleshoot' txt='*@(Plugin Exception|rpm info)*' )
            [20]=( tool='rsyslog*' txt='*@(action*action*suspended|MARK)*' )
            [21]=( tool='auditd*' txt='*@(rotating)*' )
            [22]=( tool='chronyd*' txt='*' )
            [23]=( tool='audispd*' txt='*@(is full)*' )
            [24]=( tool='gnome*' txt='*' )
            [25]=( tool='mtp-probe*' txt='*')
            [26]=( tool='neutron*' txt='*INFO*')
            [27]=( tool='nova*' txt='*INFO*')
            [28]=( tool='*' txt='*purity*audit*pureuser*' )
            [29]=( tool='influx*' txt='*HTTP*' )
            [30]=( tool='ceph-osd*' txt='*heartbeat_check*' )
            [31]=( tool=kubelet txt='*@(MountVolume.SetUp succeeded for volume*kubernetes|checking backoff for container|Found and omitted duplicated dns domain in host search line)*')
            [32]=( tool='proxy-server*' txt='*' )
            [33]=( tool='cinder-volume*' txt='*@(Reconnected to AMQP server|oslo.service*Function)*' )
            [34]=( tool='influxd*' txt='*' )
            [35]=( tool='liblogging*' txt='*@(action*action*suspended|MARK)*' )
            [36]=( tool='plasmashell' txt='*' )
            [37]=( tool='*motd*' txt='*' )
            [38]=( tool='packagekit*' txt='*' )
            [39]=( tool='org.kde*' txt='*' )
            [40]=( tool='@(krunner|ksm|kde|kactivitymanagerd)*' txt='*' )
            [41]=( tool='*powerdevil*' txt='*' )
            [42]=( tool='*kcheckpass*' txt='*' )
            [43]=( tool='*kwin_x11*' txt='*' )
            [44]=( tool='*kscreenlock*' txt='*' )
            [45]=( tool='*syslogd*' txt='*resume*' )
            [46]=( tool='*ctl_mboxlist*' txt='*' )
            [47]=( tool='*pulseaudio*' txt='*' )
            [48]=( tool='dnf' txt='*' )
            [49]=( tool='@(sendmail|sm-mta)' txt='*' )
            [50]=( tool='xrdp' txt='*' )
            [51]=( tool='gvfs*' txt='*' )
            [52]=( tool='yast-timesync*' txt='*' )
            [53]=( tool='tracker-store*' txt='*' )
            [54]=( tool='rtkit-daemon*' txt='*' )
            [55]=( tool='pipewire*' txt='*' )
            [56]=( tool='snap*' txt='*' )
            [57]=( tool='tracker*' txt='*' )
            [58]=( tool='goa-daemon*' txt='*' )
            [59]=( tool='web*php*' txt='*' )
            [60]=( tool='named' txt='*' )
            [61]=( tool='avahi*' txt='*' )
            [62]=(  tool='dockerd*' txt='*level=@(info|warning)*' )
            [63]=( tool='baloo*' txt='*' )
            [64]=( tool='wireplumber' txt='*' )
            [65]=( tool='bluetoothd' txt='*' )
        )
        [include]=(
            [0]=(
                tool=kernel
                txt='*@(error| sd |Sense|unknown partition)*'
                sev=1 tmode=keep
            )
        )
    )
)
