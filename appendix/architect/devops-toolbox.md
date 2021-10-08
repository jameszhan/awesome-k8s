#### Todos

- [ ] [HTTPie](https://httpie.io/): User-friendly cURL replacement (command-line HTTP client)
- [ ] [Packer](https://packer.io): Tool for creating identical machine images for multiple platforms
- [ ] [Vagrant](https://www.vagrantup.com/):
- [x] [Kubernetes](https://kubernetes.io/): 
- [ ] [CNCF](https://www.cncf.io/):
- [ ] [minikube](http://bit.ly/2xNk8w4)
- [ ] [pushgateway](https://github.com/prometheus/pushgateway)
- [ ] [Kafdrop – Kafka Web UI](https://github.com/obsidiandynamics/kafdrop)
- [ ] https://www.telepresence.io/discussion/how-it-works
- [ ] Try `PXE`+`Kickstart`无人值守安装系统
- [ ] Proxmox VE
- [x] ESXi
- [ ] 智能Bind系统


### 运维工具

#### `Ansible`

#### `Fabric`

##### `Fabric`在性能方面的不足
> `Fabric`的底层设计是基于`Python`的`paramiko`基础库的，它并不支持原生的`OpenSSH`，原生的`OpenSSH`的`Multiplexing`及`pipeline`的很多特性都不支持，而这些通过优化都能极大地提升性能。相对而言，`Fabric`适合集群内的自动化运维方案(集群内机器数量不多)，如果机器数量多，可以考虑`Ansible`。

#### `mussh`
> 全称是`Multihost SSH Wrapper`，它其实是一个`SSH`封装器，由一个`shell`脚本实现。通过`mussh`可以实现批量管理多台远程主机的功能。


### 虚拟化

#### `KVM`

`KVM`(`Kernel-based Virtual Machine`，基于内核的虚拟机)是一个开源的系统虚拟化模块，从`Linux 2.6.20`之后集成在`Linux`的各个主要发行版本中。它使用`Linux`自身的调度器进行管理，`KVM`的核心源码很少，这使它成为学术界的主流`VMM`之一。`KVM`的虚拟化与`OpenVZ`不同，它需要硬件支持(如`Intel VT`技术或者`AMD V`技术)，是基于硬件的完全虚拟化。

`KVM`是`Linux`下`x86`硬件平台上的全功能虚拟化解决方案，它包含一个可加载的内核模块`kvm.ko`，提供了虚拟化核心架构和处理器规范模块。`KVM`虚拟化技术允许运行多种不同类型的虚拟机，包括`Linux`和`Windows`操作系统。完全虚拟化技术的每个虚拟机都有私有的硬件，包括网卡、磁盘以及图形适配卡等。

#### `OpenVZ`

`OpenVZ`是开源软件，是基于`Linux`平台的操作系统级服务器虚拟化解决方案，它是基于`Linux`内核和作业系统的操作系统级虚拟化技术。`OpenVZ`允许在单个物理服务器上创建多个隔离的虚拟专用服务器，这些虚拟专用服务器称为`VPS`(`Virtual Private Server`)或虚拟环境(`Virtual Environment`，`VE`)。`OpenVZ`虚拟化以最大效率共享硬件和管理资源。每个虚拟服务器的运行和独立服务器完全一致，

`OpenVZ`提供了独立的根访问权限、用户、内存、处理器、IP地址、文件、应用服务、系统库文件和配置文件等。对于用户进程、应用程序都可以独立进行维护，同时，`OpenVZ`软件也为用户提供了协助自动化管理虚拟服务器的工具，通过基于模板的应用程序部署方式，可以在几分钟内创建新的虚拟服务器并投入使用。与硬件虚拟化的VMware和半虚拟化的`Xen`相比，`OpenVZ`虚拟化技术中的`Host OS`和`Guest OS`都必须是`Linux`，这是出于对性能的考虑。根据`OpenVZ`网站的说法，使用OpenVZ与使用独立的服务器相比，性能只会有1%～3%的损失。这个特点可以让`OpenVZ`充分利用硬件资源，最大限度地发挥服务器虚拟化技术的优势

#### PVE

[`Proxmox VE`(`Proxmox Virtual Environment`)](https://www.proxmox.com/)是一个虚拟化集成应用平台。

`Proxmox VE`(`Proxmox Virtual Environment`)是一个虚拟化集成应用平台。它提供了一个可运行`OpenVZ`和`KVM`的开源虚拟化平台，有方便易用的`Web界面`、基于`Java`的`UI`和内核接口，用户可以很方便地登录VM进行操作。此外，`Proxmox VE`还有简单、易用的模板功能，基于模板的应用程序部署，可以在几分钟内用简单的方法创建新的虚拟服务器并投入使用，极大降低了服务器的安装和部署成本。

`Proxmox VE`是一个基于`Debian Etch(x86_64)`版本的虚拟环境，因此不能把它安装到一个`i386`系统上。同时，如果要使用的是`KVM`，首先操作系统的`CPU`必须支持类似于`Intel VT`或者`AMD-V`的硬件虚拟化技术，然后还需要在主机`BIOS`里面将`VT-X`或`VT-D`选项打开才能真正使用。而如果仅仅使用`OpenVZ`，就不需要`CPU`的虚拟化支持了。

#### Vagrant

`Vagrant`是为了方便实现虚拟化环境而设计的，使用`Ruby`开发，基于`VirtualBox`等虚拟机管理软件的接口，提供了一个可配置、轻量级的便携式虚拟开发环境。
使用`Vagrant`可以很便捷地建立起一个虚拟环境，而且可以模拟多台虚拟机，这样我们平时还可以开发机模拟分布式系统。

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