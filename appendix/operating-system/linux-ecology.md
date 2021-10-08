# linux-ecology

## `Linux`简介

#### `Linux`操作系统的特点

1. Linux操作系统的特点
2. 良好的可移植性
3. 设备独立性
4. 多种人机交互界面
5. 多用户，多任务支持
6. 完善的网络功能
7. 多种文件系统的支持
8. 便捷的开发和维护手段

#### `Linux`优势
- 开源、免费
- 跨平台的硬件支持
- 丰富的软件支持
- 多用户多任务
- 可靠的安全性
- 良好的稳定性
- 完善的网络功能

#### `Linux`设计思想

01. 一切皆文件
> 在Linux系统中，不只数据以文件的形式存在，其他资源（包括硬件设备）也被组织为文件的形式。例如，硬盘以及硬盘中的每个分区在Linux中都被视为一个文件。
02. 整个系统由众多的小程序组成
> 在Linux中，很少有像Windows系统中那样动辄几GB的大型程序，整个Linux系统是由众多单一功能的小程序组成的。每个小程序只负责实现某一项具体功能，我们之后要学习的绝大多数Linux命令，其实各自有一个相应的小程序。如果要完成一项复杂任务，只需将相应的命令组合在一起使用即可。
03. 尽量避免与用户交互
> 避免与用户交互，是指在对系统进行管理操作的过程中，要尽量减少用户的参与。Linux（尤其是CentOS）系统，是主要用作服务器的操作系统，其操作方式与我们平常在PC 上使用的Windows系统有很大区别。由于服务器管理员不可能全天候地守护在服务器旁边，而且一名管理员往往需要同时管理成百上千台服务器，因此在服务器上执行的操作最好通过编写脚本程序来完成，从而使其自动化地完成某些功能。
04. 使用纯文本文件保存配置信息
> 无论是Linux系统本身还是系统中的应用程序，它们的配置信息往往都保存在一个纯文本的配置文件中。如果需要改动系统或程序中的某项功能，那么只需编辑相应的配置文件

## `Linux`下的重要概念

#### runlevel

- 0: halt，关闭系统，不能作为默认运行级别
- 1: single user mode，单用户模式，类似安全模式，用于故障维护
- 2: Multiuser, without NFS，与3类似，但是没有联网能力
- 3: Full multiuser mode，全功能的多用户模式
- 4: unused，保留，没有使用
- 5: X11，带有图形用户界面的全功能多用户模式
- 6: reboot，重新启动，不能作为默认运行级别

#### Linux中特殊用途的文件系统有以下类型

- `proc`: 挂载在`/proc`。`proc`是进程（process）的缩写。`/proc`目录中的子目录以系统中的`PID`命名，子目录中的文件代表的是进程的各种状态。文件`/proc/self`表示当前进程。`Linux`系统的`proc`文件系统包括大量的内核和硬件系统信息，保存在像`/proc/cpuinfo`这样的文件中。（后来有人提出将进程无关的信息从`/proc`移至`/sys`）。
- `sysfs`: 挂载在`/sys`。
- `tmpfs`: 挂载在`/run`和其他位置。通过`tmpfs`，你可以将物理内存和交换空间作为临时存储。例如，你可以将`tmpfs`挂载到任意位置，使用`size`和`nr_blocks`长选项来设置最大容量。但是请注意不要经常随意地将数据存放到`tmpfs`，这样你很容易占满系统内存，会导致程序崩溃。（多年来，`Sun Microsystems`公司使用的`tmpfs`在长时间运行后会导致一系列问题。

##### 内存文件系统

> `procfs`和`sysfs`两个伪文件系统，分别加载于"`/proc`"和"`/sys`"之上，将内核中的数据结构暴露给用户空间。或者说，这些条目是虚拟的，他们打开了深入了解操作系统运行的方便之门。

> 目录"`/proc`"为每个正在运行的进程提供了一个子目录，目录的名字就是进程标识符`(PID)`。需要读取进程信息的系统工具，如`ps`，可以从这个目录结构获得信息。

> "`/proc/sys`"之下的目录，包含了可以更改某些内核运行参数的接口。(你也可以使用专门的`sysctl`命令修改，或者使用其预加载/配置文件"`/etc/sysctl.conf`")。

> 当人们看到这个特别大的文件"`/proc/kcore`"时，常常会惊慌失措。这个文件于你的的电脑内存大小相差不多。它被用来调试内核。它是一个虚拟文件，指向系统内存，所以不必担心它的大小。

> "`/sys`"以下的目录包含了内核输出的数据结构，它们的属性，以及它们之间的链接。它同时也包含了改变某些内核 运行时参数的接口。

> `tmpfs`是一个临时文件系统，它的文件都保存在虚拟内存中。必要时，位于内存页缓存的`tmpfs`数据可能被交换到硬盘中的交换分区。

系统启动早期阶段，"`/run`"目录挂载为`tmpfs`。这样即使"`/`"挂载为只读，它也是可以被写入的。它为过渡态文件提 供了新的存储空间，同时也替代了`Filesystem Hierarchy Standar2.3`版中说明的目录位置:
- ”/var/run” → ”/run”
- ”/var/lock” → ”/run/lock” 
- ”/dev/shm” → ”/run/shm”

## `Linux`下常用工具

### `Linux`图形界面

#### Linux 图形界面四杰

- GNOME
- KDE
- XFCE
- LXDE

#### KDE主要包含以下应用程序。

- Konqueror（档案管理与网页浏览器）。
- amaroK（音乐播放器）。
- Gwenview（图像浏览器）。
- Kaffeine（媒体播放器）。
- Kate（文本编辑器）。
- Kopete（即时通讯软件）。
- KOffice（办公软件套件）。
- Kontact（个人信息管理软件）。
- KMail（电子邮件客户端）。
- Konsole（终端模拟器）。
- K3B（光盘烧录软件）。
- KDevelop（集成开发环境）。

#### GNOME下的主要应用程序如下。
- Abiword（文字处理器）。
- Epiphany（网页浏览器）。
- Evolution（联系/安排和E-mail管理）。
- Gaim（即时通信软件）。
- gedit（文本编辑器）。
- The Gimp（高级图像编辑器）。
- Gnumeric（电子表格软件）。
- GnomeMeeting（IP电话或者电话软件）。
- Inkscape（矢量绘图软件）。
- Nautilus（文件管理器）。
- Rhythmbox（类型Apple iTunes的音乐管理软件）。
- Totem（媒体播放器）。

### `Linux`其他工具

#### 图像处理

- GIMP
- Inkscape
- Cinelerra

#### 影音系统

- VLC
- MPlayer
- Xine
- GStreamer
- ffmpeg

#### 邮件客户端

- Thunderbird

#### 其他
- [ ] 博客
  - [ ] Typecho
- [ ] 下载
  - [ ] Aria2
- [ ] [ImageMagick](www.imagemagick.org)
- [ ] `Groff`是`GNU Troff`的简称，是`troff`工具的`GNU`重实现版。
- [ ] `glxgears`: 用来检测`OpenGL 3D`显卡驱动的效率小程序
- [ ] `dmidecode`: 查询系统硬件信息
- [ ] `overlay`: `Overlayfs`是一种堆叠文件系统，它依赖并建立在其它的文件系统之上，仅仅将原来底层文件系统中不同的目录进行合并，然后向用户呈现。关联内核模块为`fs/overlayfs/overlay.ko`
- [ ] `TUN`: 模块提供虚拟的`Point-to-Point`网络设备(`TUN`) 
- [ ] `TAP`: 虚拟的`Ethernet`以太网网络设备(`TAP`)
- [ ] `netfilter`: 模块提供`netfilter`防火墙能力
- [ ] `watchdog timer`驱动模块。


## 附录

### 常用软件

#### 浏览器家族

- lynx
- Midori
- Firefox
- Chrome
- Opera
- Konqueror
  - Safari
- Internet Explorer

#### 办公软件

- Microsoft Office
- Apple iWork
- WPS Office
- OpenOffice
- 永中Office

#### 可视化文本编辑

- Visual Studio Code
- TextMate
- BBEdit
- UltraEdit
- Notepad++
- Sublime Text