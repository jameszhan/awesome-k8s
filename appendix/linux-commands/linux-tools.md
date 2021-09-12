
- [ImageMagick](www.imagemagick.org)
- `Groff`是`GNU Troff`的简称，是`troff`工具的`GNU`重实现版。
- glxgears: 用来检测OpenGL 3D显卡驱动的效率小程序
- mussh的全称是MUltihost SSH Wrapper，它其实是一个SSH封装器，由一个shell脚本实现。通过mussh可以实现批量管理多台远程主机的功能。
- dmidecode: 查询系统硬件信息

- ![iptables常用主选项](../../appendix/linux-commands/images/iptables-options.jpg)

分布式块设备复制（Distributed Replicated Block Device，DRBD），是一种基于软件的、基于网络的块复制存储解决方案，主要用于对服务器之间的磁盘、分区、逻辑卷等进行数据镜像。当用户将数据写入本地磁盘时，还会将数据发送到网络中另一台主机的磁盘上，这样本地主机（主节点）与远程主机（备节点）的数据就可以保证实时同步，当本地主机出现问题，远程主机上还保留着一份相同的数据，可以继续使用，保证了数据的安全。


#### 常见构建工具
- make: [make](https://www.gnu.org/software/make)
- rake: [rake](http://rake.rubyforge.org/)
- ant: [ant](http://ant.apache.org/)
- NAnt
- MSBuild
- Psake
- Buildr
- mvn: [Maven](http://maven.apache.org/)
- gradle: [Gradle](http://www.gradle.org/)
- sbt: [Simple Build Tool](http://www.scala-sbt.org/index.html)
- lein: [Leiningen](https://leiningen.org/)


#### Fabric
##### Fabric在性能方面的不足

Fabric的底层设计是基于Python的paramiko基础库的，它并不支持原生的OpenSSH，原生的OpenSSH的Multiplexing及pipeline的很多特性都不支持，而这些通过优化都能极大地提升性能。相对而言，Fabric适合集群内的自动化运维方案（集群内机器数量不多），如果机器数量多，可以考虑Ansible。

#### Ganglia

Ganglia是一款为HPC（高性能计算）集群而设计的可扩展的分布式监控系统，它可以监视和显示集群中节点的各种状态信息，它由运行在各个节点上的gmond守护进程来采集CPU、内存、硬盘利用率、I/O负载、网络流量情况等方面的数据，然后汇总到gmetad守护进程下，使用rrdtool存储数据，最后将历史数据以曲线方式通过PHP页面呈现。
Ganglia的特点如下：
- 良好的扩展性，分层架构设计能够适应大规模服务器集群的需要。
- 负载开销低，支持高并发。
- 广泛支持各种操作系统（UNIX等）和CPU架构，支持虚拟机。

#### Centreon
Centreon是一款功能强大的分布式IT监控系统，它通过第三方组件可以实现对网络、操作系统和应用程序的监控：首先，它是开源的，我们可以免费使用它；其次，它的底层采用nagios作为监控软件，同时nagios通过ndoutil模块将监控到的数据定时写入数据库中，而Centreon实时从数据库读取该数据并通过Web界面展现监控数据；最后，我们可以通过Centreon管理和配置nagios，或者说Centreon就是nagios的一个管理配置工具，通过Centreon提供的Web配置界面，可以轻松完成nagios的各种烦琐配置。

#### xinetd
xinetd: extended internet daemon，是新一代的网络守护进程服务程序，又叫超级Internet服务器,常用来管理多种轻量级Internet服务。

##### 系统默认使用xinetd的服务可以分为如下几类。
- ① 标准Internet服务：telnet、ftp。
- ② 信息服务：finger、netstat、systat。
- ③ 邮件服务：imap、imaps、pop2、pop3、pops。
- ④ RPC服务：rquotad、rstatd、rusersd、sprayd、walld。
- ⑤ BSD服务：comsat、exec、login、ntalk、shell、talk。
- ⑥ 内部服务：chargen、daytime、echo、servers、services、time。
- ⑦ 安全服务：irc。
- ⑧ 其他服务：name、tftp、uucp。
  具体可以使用xinetd的服务在/etc/services文件中指出

#### Prometheus
默认支持Prometheus的软件或组件:
- App Connect Enterprise
- Ballerina
- BFE
- Ceph
- CockroachDB
- Collectd
- Concourse
- CRG Roller DerbyScoreboard（direct）
- Diffusion
- Docker Daemon
- Doorman（direct）
- Envoy
- Etcd（direct）
- Flink
- FreeBSD Kernel
- Grafana
- JavaMelody
- Kong
- Kubernetes（direct）
- Linkerd
- mgmt
- MidoNet
- midonet-kubernetes（direct）
- Minio
- Netdata
- Pretix
- Quobyte（direct）
- RabbitMQ
- RobustIRC
- ScyllaDB
- Skipper
- SkyDNS（direct）
- Telegraf
- Traef ik
- VerneMQ
- WeaveFlux
- Xandikos（direct）
- Zipkin