## Before your started

### Prerequisites

- A compatible Linux host. The Kubernetes project provides generic instructions for Linux distributions based on Debian and Red Hat, and those distributions without a package manager.
- `2 GB` or more of RAM per machine (any less will leave little room for your apps).
- `2 CPUs` or more.
- Full network connectivity between all machines in the cluster (public or private network is fine).
- Unique hostname, MAC address, and product_uuid for every node. 
    - You can get the MAC address of the network interfaces using the command `ip link` or `ifconfig -a`
    - The product_uuid can be checked by using the command sudo `cat /sys/class/dmi/id/product_uuid`
- Certain ports are open on your machines. See *Ports and Protocols* for more details.
- Swap disabled. You **MUST** disable swap in order for the kubelet to work properly.


## SOP

```bash
ansible-playbook -i hosts setup-once.yml -u deploy -v
```

### All Nodes

#### Network Settings

##### Disable firewall (if avaiable)

```bash
sudo systemctl disable firewalld
sudo systemctl stop firewall
```

##### Enable iptables and IPVS

```bash
# Debian or Ubuntu
sudo apt -y install ipvsadm ipset conntrack

# CentOS or Redhat
sudo yum -y install ipvsadm ipset conntrack
```

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_lc
ip_vs_wlc
ip_vs_sh
ip_vs_dh
br_netfilter
nf_conntrack
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 10
EOF

sudo sysctl --system
```

#### Disable SELinux (if avaiable)

编辑`/etc/selinux/config`文件，将`SELinux`的值设置为`disabled`。

#### Configure Linux ulimit

```bash
ulimit -SHn 65535

cat <<EOF | sudo tee /etc/security/limits.conf
* soft nofile 655360
* hard nofile 131072
* soft nproc 655350
* hard nproc 655350
* soft memlock unlimited
* hard memlock unlimited
EOF
```

#### Configure NTP

> 与NTP相比，Chrony具有以下优势。
- 同步更快，最大程度减小时间和频率的误差。
- 能够更好地响应时钟频率的快速变化。
- 初始同步后不会停止时钟，以防对需要系统时间保持单调的应用程序造成影响。
- 应对临时非对称延迟时提供更好的稳定性。
- 无须对服务器进行定期轮询，具备间歇性网络连接的系统仍然可以快速同步时钟。

```bash
# Debian or Ubuntu
sudo apt -y purge ntpd
sudo apt -y install chrony


# CentOS or Redhat
sudo yum -y purge ntpd
sudo yum -y install chrony
```

```bash
timedatectl set-timezone Asia/Shanghai
timedatectl set-ntp true

cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bak

cat <<EOF | sudo tee /etc/chrony/chrony.conf
server ntp.aliyun.com iburst
server cn.ntp.org.cn iburst
server ntp.shu.edu.cn iburst
server 0.cn.pool.ntp.org iburst
server 1.cn.pool.ntp.org iburst
server 2.cn.pool.ntp.org iburst
server 3.cn.pool.ntp.org iburst

keyfile /etc/chrony/chrony.keys
driftfile /var/lib/chrony/chrony.drift
logdir /var/log/chrony

maxupdateskew 100.0
rtcsync
makestep 1.0 3
EOF

systemctl restart chrony
```
> 其中`iburst`选项的作用是如果在一个标准的轮询间隔内没有应答，客户端会发送一定数量的包(而不是通常的一个包)给`NTP`服务器。如果在短时间内呼叫NTP服务器多次，没有出现可辨识的应答，那么本地时间将不会变化。

```bash
chronyc -a makestep
```

### Master Nodes


### Worker Nodes

#### Disable swap

```bash
swapoff -a
sed -i -r "/(.*)swap(.*)swap(.*)/d" /etc/fstab
sysctl -w vm.swappiness=0
```

## Appendix

### Ports and Protocols

#### Control plane

Protocol | Direction | Port Range | Purpose | Used By
--------|-----------|------------|---------|--------
TCP | Inbound | 8443 | Kubernetes HAProxy | All
TCP | Inbound | 6443 | Kubernetes API server | All
TCP | Inbound | 2379-2380 | etcd server client API | kube-apiserver, etcd
TCP | Inbound | 10250 | Kubelet API | Self, Control plane
TCP | Inbound | 10259 | kube-scheduler | Self
TCP | Inbound | 10257 | kube-controller-manager | Self

> Although etcd ports are included in control plane section, you can also host your own etcd cluster externally or on custom ports.

#### Worker node(s) 

Protocol | Direction | Port Range | Purpose | Used By
--------|-----------|------------|---------|--------
TCP | Inbound | 10250 | Kubelet API | Self, Control plane
TCP | Inbound | 30000-32767 | NodePort Services† | All