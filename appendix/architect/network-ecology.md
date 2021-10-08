### 常见网络协议如下:

- `ARP`：地址解析协议(Address Resolution Protocol)，将`IP`地址解析成`MAC`地址。
- `DNS`：域名解析协议。通过域名，最终得到该域名对应的`IP`地址的过程称为域名解析。
- `SNMP`：网络管理协议(Simple Network Management Protocol)。
- `DHCP`：动态主机配置协议(Dynamic Host Configuration Protocol)，`TCP/IP`网络上使客户机获得配置信息的协议。
- `FTP`：文件传输协议(File Transfer Protocol)，是一个标准协议，是在计算机和网络之间交换文件的最简单的方法。
- `HTTP`：超文本传输协议(Hypertext Transfer Protocol)。
- `HTTPS`：安全超文本传输协议(Secure Hypertext Transfer Protocol)，是由`Netscape`开发并内置于其浏览器中，用于对数据进行压缩和解压操作。
- `ICMP`：互联网控制报文协议(Internet Control Message Protocol)。
- `PING`：`Ping`命令使用`ICpop`，命令使用格式为`ping ip`，定义的消息类型有`TTL`超时、地址的请求与应答、信息的请求与应答、目的地不可到达。
- `SMTP`：简单邮件传送协议(Simple Mail Transfer Protocol)。
- `TELNET Protocol`：虚拟终端协议。
- `TFTP`：小文件传输协议(Trivial File Transfer Protocol)。
- `UDP`：用户数据报协议(User Datagram Protocol)，是用来在互联网环境中提供包交换的计算机通信协议。
- `TCP`：传输控制协议(Transmission Control Protocol)，是一种面向连接的、可靠的、基于字节流的传输层通信协议。


### 常见的`sysctl`设置

- `net.ipv4.tcp_syncookies=1`表示开启`SYN Cookies`，当出现`SYN`等待队列溢出时，启用`cookie`来处理，可防范少量的`SYN`攻击，默认为`0`，表示关闭；
- `net.ipv4.tcp_tw_reuse=1`表示开启重用，即允许将`TIME-WAIT sockets`重新用于新的`TCP`连接，默认为`0`，表示关闭；
- `net.ipv4.tcp_tw_recycle=1`表示开启`TCP`连接中`TIME-WAIT sockets`的快速回收，默认为`0`，表示关闭；
- `net.ipv4.tcp_fin_timeout=30`表示如果套接字由本端要求关闭，这个参数决定了它保持在`FIN-WAIT-2`状态的时间；
- `net.ipv4.tcp_keepalive_time=1200`表示当`keepalive`启用时，`TCP`发送`keepalive`消息的频度默认是`2`小时，改为`20`分钟；
- `net.ipv4.ip_local_port_range=1000065000`表示`CentOS`系统默认向外连接的端口范围。默认值很小，这里改为`10000`到`65000`。建议这里不要将最低值设得太低，否则可能会占用正常的端口。
- `net.ipv4.tcp_max_syn_backlog=8192`表示`SYN`队列的长度，默认为`1024`，加大队列长度为`8192`，可以容纳更多等待连接的网络连接数。
- `net.ipv4.tcp_max_tw_buckets=5000`表示系统同时保持`TIME_WAIT`套接字的最大数量，如果超过这个数字，TIME_WAIT套接字将立刻被清除并打印警告信息，默认为`180000`，改为`5000`。对于`Apache`、`Nginx`等服务器，前面介绍的几个的参数已经可以很好地减少`TIME_WAIT`套接字数量，但对于`Squid`来说效果不大，有了此参数就可以控制`TIME_WAIT`套接字的最大数量，避免`Squid`服务器被大量的`TIME_WAIT`套接字拖死。


### `iptables`

![iptables工作模式](images/iptables-man.jpg)
![iptables常用主选项](images/iptables-options.jpg)


```bash
$ sudo iptables -t nat -nL

$ ansible -m script -a 'scripts/iptables-reset.sh' -i hosts all -u deploy --become -v
```

### `LVS`

```bash
$ sudo ipvsadm -Ln

$ ansible -m script -a 'scripts/kubernetes-service.sh' -i hosts all -u deploy --become -v
```

### 网络相关内核模块

内核模块位置：/lib/modules/`uname -r`/kernel

| 内核模块       | 描述    | 位置                                 |
| ------------ | ------- | ------------------------------------ |
| br_netfilter |         | `net/bridge/br_netfilter.ko`         |
| bridge       |         | `net/bridge/bridge.ko`               |
| nf_conntrack |         | `net/netfilter/nf_conntrack.ko`      |
| ip_set       |         | `net/netfilter/ipset/ip_set.ko`      |
| xt_set       |         | `net/netfilter/xt_set.ko`            |
| ip_tables    |         | `net/ipv4/netfilter/ip_tables.ko`    |
| ipt_rpfilter |         | `net/ipv4/netfilter/ipt_rpfilter.ko` |
| ipt_REJECT   |         | `net/ipv4/netfilter/ipt_REJECT.ko`   |
| ipip         |         | `net/ipv4/ipip.ko`                   |


> `linux kernel 4.19`版本已经将`nf_conntrack_ipv4`更新为`nf_conntrack`。

```bash
cat /lib/modules/$(uname -r)/modules.dep

# 修改linux的内核参数，添加网桥过滤和地址转发功能
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
```

#### `IPVS`支持的算法

| 序号 | 标识   | 详细说明            | 模式             | 内核模块       |
| ---- | ----- | ----------------- | ---------------- | -------------- |
| 01   | rr    | Round Robin 轮询  | Static Schedule  | ip_vs_rr.ko    |
| 02   | wrr   | Weight Round Robin 加权轮 | Static Schedule  | ip_vs_wrr.ko   |
| 03   | sh    | Source Hashing 源地址Hash实现会话绑定(Session Affinity)        | Static Schedule  | ip_vs_sh.ko    |
| 04   | dh    | Destination Hashing 目标地址Hash         | Static Schedule  | ip_vs_dh.ko    |
| 05   | lc    | Least-Connection Scheduling 最少连接     | Dynamic Schedule | ip_vs_lc.ko    |
| 06   | wlc   | Weighted Least-Connection Scheduling):加权最少连接  | Dynamic Schedule | ip_vs_wlc.ko   |
| 07   | sed   | shortest expected delay scheduling 最少期望延迟  | Dynamic Schedule | ip_vs_sed.ko   |
| 08   | nq    | Never Queue Scheduling 永不排队   | Dynamic Schedule | ip_vs_nq.ko    |
| 09   | LBLC  | Locality-Based Least Connections 基于局部性的最少连接  | Dynamic Schedule | ip_vs_lblc.ko  |
| 10   | LBLCR | Locality-Based Least Connections with Replication 基于局部性的带复制功能的最少连接  | Dynamic Schedule | ip_vs_lblcr.ko |
| 11   | fo    | Weighted Fail Over 遍历虚拟服务所关联的真实服务器链表，找到还未过载(未设置IP_VS_DEST_F_OVERLOAD标志)的且权重最高的真实服务器，进行调度  | Dynamic Schedule | ip_vs_fo.ko    |
| 12   | OVF   | Overflow-connection 调度算法 遍历虚拟服务相关联的真实服务器链表，找到权重值最高的可用真实服务器。一个可用的真实服务器需要同时满足以下条件：1. 未过载(未设置IP_VS_DEST_F_OVERLOAD标志)真实服务器2. 当前的活动连接数量小于其权重值 3.其权重值不为零 | Dynamic Schedule | ip_vs_ovf.ko   |





