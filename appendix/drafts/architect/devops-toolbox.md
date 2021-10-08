### 运维工具

#### `Ansible`

#### `Fabric`

##### `Fabric`在性能方面的不足
> `Fabric`的底层设计是基于`Python`的`paramiko`基础库的，它并不支持原生的`OpenSSH`，原生的`OpenSSH`的`Multiplexing`及`pipeline`的很多特性都不支持，而这些通过优化都能极大地提升性能。相对而言，`Fabric`适合集群内的自动化运维方案(集群内机器数量不多)，如果机器数量多，可以考虑`Ansible`。

#### `mussh`
> 全称是`Multihost SSH Wrapper`，它其实是一个`SSH`封装器，由一个`shell`脚本实现。通过`mussh`可以实现批量管理多台远程主机的功能。

### 常用容器

#### BusyBox

```conf
[           cpio           fdformat     ifenslave  lspci       nsenter       rmmod              su            udhcpc
[[          crond          fdisk        ifplugd    lsscsi      nslookup      route              sulogin       udhcpc6
acpid       crontab        fgconsole    ifup       lsusb       ntpd          rpm                sum           udhcpd
add-shell   cryptpw        fgrep        inetd      lzcat       nuke          rpm2cpio           sv            udpsvd
addgroup    cttyhack       find         init       lzma        od            rtcwake            svc           uevent
adduser     cut            findfs       insmod     lzop        openvt        run-init           svlogd        umount
adjtimex    date           flock        install    makedevs    partprobe     run-parts          svok          uname
ar          dc             fold         ionice     makemime    passwd        runlevel           swapoff       unexpand
arch        dd             free         iostat     man         paste         runsv              swapon        uniq
arp         deallocvt      freeramdisk  ip         md5sum      patch         runsvdir           switch_root   unix2dos
arping      delgroup       fsck         ipaddr     mdev        pgrep         rx                 sync          unlink
ash         deluser        fsck.minix   ipcalc     mesg        pidof         script             sysctl        unlzma
awk         depmod         fsfreeze     ipcrm      microcom    ping          scriptreplay       syslogd       unshare
base32      devmem         fstrim       ipcs       mim         ping6         sed                tac           unxz
base64      df             fsync        iplink     mkdir       pipe_progres  sendmail           tail          unzip
basename    dhcprelay      ftpd         ipneigh    mkdosfs     pivot_root    seq                tar           uptime
bc          diff           ftpget       iproute    mke2fs      pkill         setarch            taskset       users
beep        dirname        ftpput       iprule     mkfifo      pmap          setconsole         tc            usleep
blkdiscard  dmesg          fuser        iptunnel   mkfs.ext2   popmaildir    setfattr           tcpsvd        uudecode
blkid       dnsd           getconf      kbd_mode   mkfs.minix  poweroff      setfont            tee           uuencode
blockdev    dnsdomainname  getopt       kill       mkfs.vfat   powertop      setkeycodes        telnet        vconfig
bootchartd  dos2unix       getty        killall    mknod       printenv      setlogcons         telnetd       vi
brctl       dpkg           grep         killall5   mkpasswd    printf        setpriv            test          vlock
bunzip2     dpkg-deb       groups       klogd      mkswap      ps            setserial          tftp          volname
busybox     du             gunzip       last       mktemp      pscan         setsid             tftpd         w
bzcat       dumpkmap       gzip         less       modinfo     pstree        setuidgid          time          wall
bzip2       dumpleases     halt         link       modprobe    pwd           sh                 timeout       watch
cal         echo           hd           linux32    more        pwdx          sha1sum            top           watchdog
cat         ed             hdparm       linux64    mount       raidautorun   sha256sum          touch         wc
chat        egrep          head         linuxrc    mountpoint  rdate         sha3sum            tr            wget
chattr      eject          hexdump      ln         mpstat      rdev          sha512sum          traceroute    which
chgrp       env            hexedit      loadfont   mt          readahead     showkey            traceroute6   who
chmod       envdir         hostid       loadkmap   mv          readlink      shred              true          whoami
chown       envuidgid      hostname     logger     nameif      readprofile   shuf               truncate      whois
chpasswd    ether-wake     httpd        login      nanddump    realpath      slattach           ts            xargs
chpst       expand         hush         logname    nandwrite   reboot        sleep              tty           xxd
chroot      expr           hwclock      logread    nbd-client  reformime     smemcap            ttysize       xz
chrt        factor         i2cdetect    losetup    nc          remove-shell  softlimit          tunctl        xzcat
chvt        fakeidentd     i2cdump      lpd        netstat     renice        sort               ubiattach     yes
cksum       fallocate      i2cget       lpq        nice        reset         split              ubidetach     zcat
clear       false          i2cset       lpr        nl          resize        ssl_client         ubimkvol      zcip
cmp         fatattr        i2ctransfer  ls         nmeter      resume        start-stop-daemon  ubirename
comm        fbset          id           lsattr     nohup       rev           stat               ubirmvol
conspy      fbsplash       ifconfig     lsmod      nologin     rm            strings            ubirsvol
cp          fdflush        ifdown       lsof       nproc       rmdir         stty               ubiupdatevol
```

#### CirrOS

> `CirrOS`是设计用来进行云计算环境测试的`Linux`微型发行版，它拥有HTTP客户端工具`curl`等。

```bash
$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
# 或
$ docker run -it --rm cirros sh
```

```bash
$ curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" http://ws.zizhizhan.local/ws/
```

#### `/sbin`

```conf
acpid         cirros-ds        e2mmpstatus  fsfreeze  inotifyd  loadkmap   mkfs.ext4          rmmod              switch_root
arp           cirros-status    e2undo       fstrim    insmod    logsave    mkfs.vfat          route              sysctl
badblocks     cirros-userdata  e4crypt      getty     ip        losetup    mklost+found       run-init           syslogd
blkdiscard    ctrlaltdel       fdisk        growpart  ipaddr    lsmod      mkswap             runlevel           tc
blkid         debugfs          filefrag     halt      iplink    makedevs   modprobe           setconsole         tune2fs
blkzone       depmod           findfs       hdparm    ipneigh   mdev       nameif             sfdisk             udhcpc
blockdev      devmem           freeramdisk  hwclock   iproute   mkdosfs    pivot_root         start-stop-daemon  uevent
cfdisk        dumpe2fs         fsck         ifconfig  iprule    mke2fs     poweroff           sulogin            vconfig
chcpu         e2freefrag       fsck.ext2    ifdown    iptunnel  mkfs       reboot             swaplabel          watchdog
cirros-apply  e2fsck           fsck.ext3    ifup      klogd     mkfs.ext2  resize-filesystem  swapoff            wipefs
cirros-dhcpc  e2label          fsck.ext4    init      ldconfig  mkfs.ext3  resize2fs          swapon
```

#### `/bin`

```conf
arch      chown         dmesg          findmnt   linux32           mk_cmds     netstat        pwd        setserial  true
ash       cirros-per    dnsdomainname  getopt    linux64           mkdir       nice           reformime  sh         umount
base64    cirros-query  dumpkmap       grep      ln                mknod       nuke           resume     sleep      uname
bbconfig  compile_et    echo           growroot  login             mktemp      pidof          rm         stat       usleep
busybox   cp            egrep          gunzip    ls                more        ping           rmdir      stty       vi
cat       cpio          false          gzip      lsattr            mount       ping6          run-parts  su         watch
chattr    date          fatattr        hostname  lsblk             mountpoint  pipe_progress  sed        sync       zcat
chgrp     dd            fdflush        kill      lxc-is-container  mt          printenv       setarch    tar
chmod     df            fgrep          link      makemime          mv          ps             setpriv    touch
```

#### `/usr/sbin`

```conf
addgroup  chpasswd  delpart   ether-wake  i2cdump  killall5    ndisc6          partx        resizepart  ubirename
addpart   chroot    deluser   fdformat    i2cget   ldattach    odhcp6c         rdate        rtcwake     ubirmvol
adduser   crond     dnsd      fsfreeze    i2cset   loadfont    odhcp6c-update  rdisc6       setlogcons  ubirsvol
arping    delgroup  dropbear  i2cdetect   inetd    nbd-client  partprobe       readprofile  ubimkvol    ubiupdatevol
```

#### `/usr/bin`

```conf
[           crontab          fallocate  ipcrm        lspci     od                screen         ssl_client   truncate   w
[[          curl             fincore    ipcs         lsscsi    openvt            script         strings      tty        wall
ar          cut              find       isosize      lsusb     parse-interfaces  scriptreplay   sudo         uname26    wc
awk         cvtsudoers       flock      json2fstree  lzcat     passwd            seq            sudoedit     uniq       wget
basename    dbclient         fold       killall      lzma      paste             setarch        sudoreplay   unix2dos   whereis
blkdiscard  dc               free       last         mcookie   patch             setfattr       svc          unlink     which
bunzip2     deallocvt        fuser      ldd          md5sum    printf            setkeycodes    svok         unlzma     who
bzcat       diff             getconf    less         mesg      prlimit           setsid         tac          unshare    whoami
choom       dirname          getopt     linux32      microcom  pscan             sha1sum        tail         unxz       whois
chrt        dos2unix         groups     linux64      mkfifo    pstree            sha256sum      tee          unzip      x86_64
chvt        dropbearconvert  head       logger       mkpasswd  pwdx              sha3sum        telnet       uptime     xargs
cksum       dropbearkey      hexdump    logname      namei     readlink          sha512sum      test         users      xxd
clear       du               hexedit    look         nc        realpath          shred          tftp         uudecode   xz
cmp         ec2metadata      hostid     lscpu        nl        renice            shuf           time         uuencode   xzcat
col         eject            i386       lsipc        nohup     reset             sort           top          uuidgen    yes
colcrt      env              id         lslocks      nproc     resize            ssh            tr           uuidparse
colrm       expr             install    lsns         nsenter   rev               ssh-add-key    traceroute   vlock
column      factor           ipcmk      lsof         nslookup  scp               ssh-import-id  traceroute6  volname
```