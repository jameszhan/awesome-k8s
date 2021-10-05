内核模块位置：/lib/modules/`uname -r`/kernel

内核模块 | 描述 | 位置
-------|------|-----
overlay | Overlayfs是一种堆叠文件系统，它依赖并建立在其它的文件系统之上，仅仅将原来底层文件系统中不同的目录进行合并，然后向用户呈现 | `fs/overlayfs/overlay.ko`
br_netfilter | | `net/bridge/br_netfilter.ko`
bridge || `net/bridge/bridge.ko`
nf_conntrack || `net/netfilter/nf_conntrack.ko`
ip_set || `net/netfilter/ipset/ip_set.ko`
xt_set || `net/netfilter/xt_set.ko`
ip_tables || `net/ipv4/netfilter/ip_tables.ko`
ipt_rpfilter || `net/ipv4/netfilter/ipt_rpfilter.ko`
ipt_REJECT || `net/ipv4/netfilter/ipt_REJECT.ko`
ipip || `net/ipv4/ipip.ko`


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

序号 | 标识 | 详细说明 | 模式 | 内核模块
----|------|--------|------|--------
01 | rr | Round Robin 轮询 | Static Schedule | ip_vs_rr.ko
02 | wrr | Weight Round Robin 加权轮询 | Static Schedule | ip_vs_wrr.ko
03 | sh | Source Hashing 源地址Hash实现会话绑定(Session Affinity) | Static Schedule | ip_vs_sh.ko
04 | dh | Destination Hashing 目标地址Hash | Static Schedule | ip_vs_dh.ko
05 | lc | Least-Connection Scheduling 最少连接 | Dynamic Schedule | ip_vs_lc.ko
06 | wlc | Weighted Least-Connection Scheduling):加权最少连接 | Dynamic Schedule | ip_vs_wlc.ko
07 | sed | shortest expected delay scheduling 最少期望延迟 | Dynamic Schedule | ip_vs_sed.ko
08 | nq | Never Queue Scheduling 永不排队 | Dynamic Schedule | ip_vs_nq.ko
09 | LBLC | Locality-Based Least Connections 基于局部性的最少连接 | Dynamic Schedule | ip_vs_lblc.ko
10 | LBLCR | Locality-Based Least Connections with Replication 基于局部性的带复制功能的最少连接 | Dynamic Schedule | ip_vs_lblcr.ko
11 | fo | Weighted Fail Over 遍历虚拟服务所关联的真实服务器链表，找到还未过载(未设置IP_VS_DEST_F_OVERLOAD标志)的且权重最高的真实服务器，进行调度 | Dynamic Schedule | ip_vs_fo.ko
12 | OVF | Overflow-connection 调度算法 遍历虚拟服务相关联的真实服务器链表，找到权重值最高的可用真实服务器。一个可用的真实服务器需要同时满足以下条件：1. 未过载(未设置IP_VS_DEST_F_OVERLOAD标志)真实服务器2. 当前的活动连接数量小于其权重值 3.其权重值不为零 | Dynamic Schedule | ip_vs_ovf.ko





