

```bash
$ cat /etc/sysctl.conf
```

- `net.ipv4.tcp_syncookies=1`表示开启`SYN Cookies`，当出现`SYN`等待队列溢出时，启用`cookie`来处理，可防范少量的`SYN`攻击，默认为`0`，表示关闭；
- `net.ipv4.tcp_tw_reuse=1`表示开启重用，即允许将`TIME-WAIT sockets`重新用于新的`TCP`连接，默认为`0`，表示关闭；
- `net.ipv4.tcp_tw_recycle=1`表示开启`TCP`连接中`TIME-WAIT sockets`的快速回收，默认为`0`，表示关闭；
- `net.ipv4.tcp_fin_timeout=30`表示如果套接字由本端要求关闭，这个参数决定了它保持在`FIN-WAIT-2`状态的时间；
- `net.ipv4.tcp_keepalive_time=1200`表示当`keepalive`启用时，`TCP`发送`keepalive`消息的频度默认是`2`小时，改为`20`分钟；
- `net.ipv4.ip_local_port_range=1000065000`表示`CentOS`系统默认向外连接的端口范围。默认值很小，这里改为`10000`到`65000`。建议这里不要将最低值设得太低，否则可能会占用正常的端口。
- `net.ipv4.tcp_max_syn_backlog=8192`表示`SYN`队列的长度，默认为`1024`，加大队列长度为`8192`，可以容纳更多等待连接的网络连接数。
- `net.ipv4.tcp_max_tw_buckets=5000`表示系统同时保持`TIME_WAIT`套接字的最大数量，如果超过这个数字，TIME_WAIT套接字将立刻被清除并打印警告信息，默认为`180000`，改为`5000`。对于`Apache`、`Nginx`等服务器，前面介绍的几个的参数已经可以很好地减少`TIME_WAIT`套接字数量，但对于`Squid`来说效果不大，有了此参数就可以控制`TIME_WAIT`套接字的最大数量，避免`Squid`服务器被大量的`TIME_WAIT`套接字拖死。