#### GNU 开源软件具有的文件和目录示例

|-- AUTHORS 　　　　　　　作者名单
|-- autogen.sh 　　　　　 自动配置的脚本程序
|-- ChangeLog 　　　　　　软件修改、升级日志文件
|-- configure.ac 　　　　自动配置的脚本文件
|-- README 　　　　　　　 关于软件的说明文档
|-- COPYING 　　　　　　　版权协议文件
|-- configure 　　　　　　用于配置编译环境的可执行文件
|-- Makefile 　　　　　　 GNU Make 脚本
|-- GNUMakefile 　　　　 GNU Make 脚本
|-- CMakeLists.txt 　　　用于 cmake 配置编译环境的脚本
|-- INSTALL 　　　　　　　安装说明文档
|-- src/　　　　　　　　 包含源程序的目录
|-- include/　　　　　　 软件自身的头文件目录
|-- man/　　　　　　　　 包含帮助手册的目录
|-- doc/ 或　 docs/　　　 文档目录
`-- po/　　　　　　　　　用于多语言支持的字符串转换文档的目

#### Linux 图形界面四杰

- GNOME
- KDE
- XFCE
- LXDE

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



#### Linux中特殊用途的文件系统有以下类型

- `proc`: 挂载在`/proc`。`proc`是进程（process）的缩写。`/proc`目录中的子目录以系统中的`PID`命名，子目录中的文件代表的是进程的各种状态。文件`/proc/self`表示当前进程。`Linux`系统的`proc`文件系统包括大量的内核和硬件系统信息，保存在像`/proc/cpuinfo`这样的文件中。（后来有人提出将进程无关的信息从`/proc`移至`/sys`。）
- `sysfs`: 挂载在`/sys`。
- `tmpfs`: 挂载在`/run`和其他位置。通过`tmpfs`，你可以将物理内存和交换空间作为临时存储。例如，你可以将`tmpfs`挂载到任意位置，使用`size`和`nr_blocks`长选项来设置最大容量。但是请注意不要经常随意地将数据存放到`tmpfs`，这样你很容易占满系统内存，会导致程序崩溃。（多年来，`Sun Microsystems`公司使用的`tmpfs`在长时间运行后会导致一系列问题。