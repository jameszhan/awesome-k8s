
#### `/sbin`

```conf
acpid              cirros-ds          e2mmpstatus        fsfreeze           inotifyd           loadkmap           mkfs.ext4          rmmod              switch_root
arp                cirros-status      e2undo             fstrim             insmod             logsave            mkfs.vfat          route              sysctl
badblocks          cirros-userdata    e4crypt            getty              ip                 losetup            mklost+found       run-init           syslogd
blkdiscard         ctrlaltdel         fdisk              growpart           ipaddr             lsmod              mkswap             runlevel           tc
blkid              debugfs            filefrag           halt               iplink             makedevs           modprobe           setconsole         tune2fs
blkzone            depmod             findfs             hdparm             ipneigh            mdev               nameif             sfdisk             udhcpc
blockdev           devmem             freeramdisk        hwclock            iproute            mkdosfs            pivot_root         start-stop-daemon  uevent
cfdisk             dumpe2fs           fsck               ifconfig           iprule             mke2fs             poweroff           sulogin            vconfig
chcpu              e2freefrag         fsck.ext2          ifdown             iptunnel           mkfs               reboot             swaplabel          watchdog
cirros-apply       e2fsck             fsck.ext3          ifup               klogd              mkfs.ext2          resize-filesystem  swapoff            wipefs
cirros-dhcpc       e2label            fsck.ext4          init               ldconfig           mkfs.ext3          resize2fs          swapon
```

#### `/bin`

```conf
arch              chown             dmesg             findmnt           linux32           mk_cmds           netstat           pwd               setserial         true
ash               cirros-per        dnsdomainname     getopt            linux64           mkdir             nice              reformime         sh                umount
base64            cirros-query      dumpkmap          grep              ln                mknod             nuke              resume            sleep             uname
bbconfig          compile_et        echo              growroot          login             mktemp            pidof             rm                stat              usleep
busybox           cp                egrep             gunzip            ls                more              ping              rmdir             stty              vi
cat               cpio              false             gzip              lsattr            mount             ping6             run-parts         su                watch
chattr            date              fatattr           hostname          lsblk             mountpoint        pipe_progress     sed               sync              zcat
chgrp             dd                fdflush           kill              lxc-is-container  mt                printenv          setarch           tar
chmod             df                fgrep             link              makemime          mv                ps                setpriv           touch
```

#### `/usr/sbin`

```conf
addgroup        chpasswd        delpart         ether-wake      i2cdump         killall5        ndisc6          partx           resizepart      ubirename
addpart         chroot          deluser         fdformat        i2cget          ldattach        odhcp6c         rdate           rtcwake         ubirmvol
adduser         crond           dnsd            fsfreeze        i2cset          loadfont        odhcp6c-update  rdisc6          setlogcons      ubirsvol
arping          delgroup        dropbear        i2cdetect       inetd           nbd-client      partprobe       readprofile     ubimkvol        ubiupdatevol
```

#### `/usr/bin`

```conf
[                 crontab           fallocate         ipcrm             lspci             od                screen            ssl_client        truncate          w
[[                curl              fincore           ipcs              lsscsi            openvt            script            strings           tty               wall
ar                cut               find              isosize           lsusb             parse-interfaces  scriptreplay      sudo              uname26           wc
awk               cvtsudoers        flock             json2fstree       lzcat             passwd            seq               sudoedit          uniq              wget
basename          dbclient          fold              killall           lzma              paste             setarch           sudoreplay        unix2dos          whereis
blkdiscard        dc                free              last              mcookie           patch             setfattr          svc               unlink            which
bunzip2           deallocvt         fuser             ldd               md5sum            printf            setkeycodes       svok              unlzma            who
bzcat             diff              getconf           less              mesg              prlimit           setsid            tac               unshare           whoami
choom             dirname           getopt            linux32           microcom          pscan             sha1sum           tail              unxz              whois
chrt              dos2unix          groups            linux64           mkfifo            pstree            sha256sum         tee               unzip             x86_64
chvt              dropbearconvert   head              logger            mkpasswd          pwdx              sha3sum           telnet            uptime            xargs
cksum             dropbearkey       hexdump           logname           namei             readlink          sha512sum         test              users             xxd
clear             du                hexedit           look              nc                realpath          shred             tftp              uudecode          xz
cmp               ec2metadata       hostid            lscpu             nl                renice            shuf              time              uuencode          xzcat
col               eject             i386              lsipc             nohup             reset             sort              top               uuidgen           yes
colcrt            env               id                lslocks           nproc             resize            ssh               tr                uuidparse
colrm             expr              install           lsns              nsenter           rev               ssh-add-key       traceroute        vlock
column            factor            ipcmk             lsof              nslookup          scp               ssh-import-id     traceroute6       volname
```