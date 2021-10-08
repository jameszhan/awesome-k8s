
## 常见的集群监控系统

### 开源监控系统

> `Linux`运维中的监控体系有 `Nagios`、`Cacti`、`Zabbix`、`open-falco`、`lepus` 等。

- `Nagios`
- `Zabbix`
- `Cacti`
- `Mrtg`
- `Gangila`

#### 主流监控产品的对比(2019)

| 产品 | 部署难度 | 备注 |
| ---------- | -------- | ------------------------------------------------ |
| `Nagios` | 简单 | 慢慢弃用 |
| `Cacti` | 简单 | 慢慢弃用 |
| `Zabbix` | 简单 | 越来越多的企业使用，并进行二次开发 |
| `Open-falco` | 烦琐 | 较少使用，性能佳，但企业较少使用(小米开源) |
| `Lepus` | 相对简单 | 侧重 `MySQL` 监控 |
| `Grafana` | 简单 | 将数据插入 `influxdb`，结合 `Grafana` 进行展现，灵活 |

#### `Ganglia`

`Ganglia`是一款为`HPC`(高性能计算)集群而设计的可扩展的分布式监控系统，它可以监视和显示集群中节点的各种状态信息，它由运行在各个节点上的gmond守护进程来采集`CPU`、内存、硬盘利用率、`I/O`负载、网络流量情况等方面的数据，然后汇总到`gmetad`守护进程下，使用`rrdtool`存储数据，最后将历史数据以曲线方式通过`PHP`页面呈现。

##### `Ganglia`的特点如下：

- 良好的扩展性，分层架构设计能够适应大规模服务器集群的需要。
- 负载开销低，支持高并发。
- 广泛支持各种操作系统(`UNIX`等)和`CPU`架构，支持虚拟机。

#### `Centreon`

`Centreon`是一款功能强大的分布式IT监控系统，它通过第三方组件可以实现对网络、操作系统和应用程序的监控：首先，它是开源的，我们可以免费使用它；其次，它的底层采用`nagios`作为监控软件，同时`nagios`通过`ndoutil`模块将监控到的数据定时写入数据库中，而`Centreon`实时从数据库读取该数据并通过`Web`界面展现监控数据；最后，我们可以通过`Centreon`管理和配置`nagios`，或者说`Centreon`就是`nagios`的一个管理配置工具，通过`Centreon`提供的`Web`配置界面，可以轻松完成`nagios`的各种烦琐配置。

#### `xinetd`

`xinetd`: `extended internet daemon`，是新一代的网络守护进程服务程序，又叫超级`Internet`服务器,常用来管理多种轻量级`Internet`服务。

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