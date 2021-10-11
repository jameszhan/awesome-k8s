- [kind](https://kind.sigs.k8s.io/): Run local Kubernetes cluster in Docker
- [minikube](https://minikube.sigs.k8s.io/): Run a Kubernetes cluster locally

- kubeadm：用来初始化集群的指令。
- kubelet：在集群中的每个节点上用来启动 Pod 和容器等。运行在集群中每个节点上的节点代理，负责根据 pod 规格来创建 pod 并运行其包含的容器。
- kubectl：用来与集群通信的命令行工具。
- kube-apiserver: 该组件对外暴露了 Kubernetes 的 API 接口，是 Kubernetes 的前端控制层。
- etcd: 这是一个键值数据库，用来保存集群数据。
- kube-scheduler: 调度器的主要作用是监控新创建的 pod（这是 Kubernetes 集群内的一组容器的集合），为这些 pod 找到最合适的节点，并将 pod 调度到这个节点上。
- kube-controller-manager: 管理一系列的控制器，这些控制器负责节点故障的恢复，维持服务实例的数量等工作。
- cloud-controller-manager: 负责管理与底层云服务提供商交互的控制器。
- kube-proxy: 责维护节点上的网络规则并执行连接转发。

| name                    | description |
| ----------------------- | ---------------------------- |
| kubectl                 | a command line client for running commands against Kubernetes clusters. |
| kubelet                 | Kubernetes “node agent” that runs on each node in Kubernetes. |
| kubeadm                 | Tool for bootstrapping Kubernetes clusters.  |
| kube-proxy              | Kubernetes network proxy that runs on each node.   |
| kube-apiserver          | Kubernetes master component that exposes the Kubernetes API. |
| kube-scheduler          | Kubernetes master component that assigns each newly created pod to a node.  |
| kube-controller-manager | Kubernetes master component that runs controllers.   |
| kubernetes-worker       | A complete Kubernetes worker  |
| kubefed                 | kubefed controls the Kubernetes cluster federation manager.  |
| kubefedctl              | command line tool to join clusters, enable type federation, and convert resources to their federated equivalents  |
| Lens                    | The Kubernetes IDE |
| helm                    | The Kubernetes package manager  |
| etcd                    | Resilient key-value store by CoreOS  |
| etcd-manager            | A free, cross-platform ETCD v3 client which allows you to manage your ETCD via a modern, easy to use and dynamic UI. Available for Windows, Linux and MacOS X. |
| cdk-addons              | Addons for Canonical Kubernetes  |

### 常用端口

#### 控制平面节点

| 协议 | 方向 | 端口范围  | 作用                    | 使用者                       |
| ---- | ---- | --------- | ----------------------- | ---------------------------- |
| TCP  | 入站 | 6443      | Kubernetes API 服务器   | 所有组件                     |
| TCP  | 入站 | 2379-2380 | etcd 服务器客户端 API   | kube-apiserver, etcd         |
| TCP  | 入站 | 10250     | Kubelet API             | kubelet 自身、控制平面组件   |
| TCP  | 入站 | 10251     | kube-scheduler          | kube-scheduler 自身          |
| TCP  | 入站 | 10252     | kube-controller-manager | kube-controller-manager 自身 |

#### 工作节点

| 协议 | 方向 | 端口范围    | 作用          | 使用者                     |
| ---- | ---- | ----------- | ------------- | -------------------------- |
| TCP  | 入站 | 10250       | Kubelet API   | kubelet 自身、控制平面组件 |
| TCP  | 入站 | 30000-32767 | NodePort 服务 | 所有组件                   |

### 常见进程

| NAMESPACE   | NAME                                | READY | STATUS  | RESTARTS | AGE | IP            | NODE        |
| ----------- | ----------------------------------- | ----- | ------- | -------- | --- | ------------- | ----------- |
| kube-system | kube-scheduler-k8s-node001          | 1/1   | Running | 1        | 16h | 192.168.1.161 | k8s-node001 |
| kube-system | etcd-k8s-node001                    | 1/1   | Running | 1        | 16h | 192.168.1.161 | k8s-node001 |
| kube-system | kube-apiserver-k8s-node001          | 1/1   | Running | 1        | 16h | 192.168.1.161 | k8s-node001 |
| kube-system | kube-controller-manager-k8s-node001 | 1/1   | Running | 1        | 16h | 192.168.1.161 | k8s-node001 |
| kube-system | kube-flannel-ds-q9jbf               | 1/1   | Running | 1        | 15h | 192.168.1.161 | k8s-node001 |
| kube-system | kube-flannel-ds-g7w5p               | 1/1   | Running | 1        | 15h | 192.168.1.162 | k8s-node002 |
| kube-system | kube-flannel-ds-ckpt4               | 1/1   | Running | 1        | 15h | 192.168.1.163 | k8s-node003 |
| kube-system | kube-flannel-ds-xt69k               | 1/1   | Running | 1        | 15h | 192.168.1.165 | k8s-node005 |
| kube-system | kube-flannel-ds-8m6k5               | 1/1   | Running | 1        | 15h | 192.168.1.166 | k8s-node006 |
| kube-system | kube-flannel-ds-jv2mp               | 1/1   | Running | 1        | 15h | 192.168.1.167 | k8s-node007 |
| kube-system | kube-flannel-ds-g24g8               | 1/1   | Running | 1        | 15h | 192.168.1.168 | k8s-node008 |
| kube-system | kube-proxy-t524r                    | 1/1   | Running | 1        | 16h | 192.168.1.161 | k8s-node001 |
| kube-system | kube-proxy-zfj4j                    | 1/1   | Running | 1        | 16h | 192.168.1.162 | k8s-node002 |
| kube-system | kube-proxy-smzmf                    | 1/1   | Running | 1        | 16h | 192.168.1.163 | k8s-node003 |
| kube-system | kube-proxy-fws2m                    | 1/1   | Running | 1        | 16h | 192.168.1.165 | k8s-node005 |
| kube-system | kube-proxy-qh79z                    | 1/1   | Running | 1        | 16h | 192.168.1.166 | k8s-node006 |
| kube-system | kube-proxy-9ff6s                    | 1/1   | Running | 1        | 16h | 192.168.1.167 | k8s-node007 |
| kube-system | kube-proxy-wwhh2                    | 1/1   | Running | 1        | 16h | 192.168.1.168 | k8s-node008 |
| kube-system | coredns-558bd4d5db-s8bb8            | 1/1   | Running | 1        | 16h | 10.244.2.3    | k8s-node002 |
| kube-system | coredns-558bd4d5db-sf9qh            | 1/1   | Running | 1        | 16h | 10.244.4.3    | k8s-node003 |

#### Master Node

k8s_kube-flannel_kube-flannel-ds
k8s_kube-proxy_kube-proxy
k8s_kube-scheduler_kube-scheduler
k8s_kube-controller-manager_kube-controller-manager
k8s_kube-apiserver_kube-apiserver
k8s_etcd_etcd

#### Worker Node

--k8s_coredns_coredns--
k8s_kube-flannel_kube-flannel-ds
k8s_kube-proxy_kube-proxy





| name                    | description |
| ----------------------- | ---------------------------- |
| kubectl                 | a command line client for running commands against Kubernetes clusters. |
| kubelet                 | Kubernetes “node agent” that runs on each node in Kubernetes. |
| kubeadm                 | Tool for bootstrapping Kubernetes clusters.  |
| kube-proxy              | Kubernetes network proxy that runs on each node.   |
| kube-apiserver          | Kubernetes master component that exposes the Kubernetes API. |
| kube-scheduler          | Kubernetes master component that assigns each newly created pod to a node.  |
| kube-controller-manager | Kubernetes master component that runs controllers.   |
| kubernetes-worker       | A complete Kubernetes worker  |
| kubefed                 | kubefed controls the Kubernetes cluster federation manager.  |
| kubefedctl              | command line tool to join clusters, enable type federation, and convert resources to their federated equivalents  |
| Lens                    | The Kubernetes IDE |
| helm                    | The Kubernetes package manager  |
| etcd                    | Resilient key-value store by CoreOS  |
| etcd-manager            | A free, cross-platform ETCD v3 client which allows you to manage your ETCD via a modern, easy to use and dynamic UI. Available for Windows, Linux and MacOS X. |
| cdk-addons              | Addons for Canonical Kubernetes  |





docker: Docker container runtime
MicroK8s: Lightweight Kubernetes for workstations and appliances
eks: The eks snap packages all the Kubernetes binaries of Amazon EKS Distro (EKS-D) and combines them with a MicroK8s like experience, for an opinionated, self-healing, highly available EKS-compatible Kubernetes anywhere.

Nextcloud: Nextcloud Server - A safe home for all your data
prometheus: The Prometheus monitoring system and time series database
Juju: A model-driven operator lifecycle manager
LXD: System container and virtual machine manager
keepalived: High availability VRRP/BFD and load-balancing for Linux
kata-containers: Lightweight virtual machines that seamlessly plug into the containers ecosystem



Google Cloud SDK: Command-line interface for Google Cloud Platform products and services
Microsoft Azure Storage Explorer: Optimize your Azure storage management
aws-cli: Universal Command Line Interface for Amazon Web Services
doctl: The official DigitalOcean command line interface
heroku: CLI client for Heroku
influx: Command-line client for interacting with InfluxDB
influxdb: Scalable datastore for metrics, events, and real-time analytics.

robomongo: MongoDB management tool
NATs messaging server: High-Performance server for NATS, the cloud native messaging system
postgresql: PostgreSQL is a powerful, open source object-relational database system.

Stubb: A Docker utility that allows you to display information on Docker images, tags, and layers as well as Docker Hub metrics.

amazon-ssm-agent: Agent to enable remote management of your Amazon EC2 instance configuration
AWS IoT Greengrass: AWS supported software that extends cloud capabilities to local devices.
MAAS CLI: CLI to communicate with a MAAS region providing total automation of your physical servers for amazing data center operational efficiency.
MAAS (Metal as a Service): Metal as a Service -- MAAS -- lets you treat physical servers like virtual machines in the cloud. Rather than having to manage each server individually, MAAS turns your bare metal into an elastic cloud-like resource.

openstackclients: OpenStackClient (aka OSC) is a command-line client for OpenStack that brings the command set for Compute, Identity, Image, Object Store and Block Storage APIs together in a single shell with a uniform command structure.
microstack: MicroStack gives you an easy way to develop and test OpenStack workloads on your laptop or in a virtual machine.

certbot: Automatically configure HTTPS using Let's Encrypt
travis-worker: Run your Travis CI builds on your own infrastructure

mosquitto: Eclipse Mosquitto MQTT broker
minidlna: server software with the aim of being fully compliant with DLNA/UPnP clients.
streamsheets: A no-code platform for processing streaming data in a spreadsheet interface

Multipass: a tool to launch and manage VMs on Windows, Mac and Linux that simulates a cloud environment with support for cloud-init. Get Ubuntu on-demand with clean integration to your IDE and version control on your native platform.
multipass-sshfs: SSHFS allows you to mount a remote filesystem using SFTP via Multipass. Use multipass mount to mount a host directory in a Multipass instance.


restic: Fast, secure, efficient backup program.
http-to-https: An http to https redirect microservice.
sync-agent: Infobaleen's sync agent makes it easy to sync data to and from your Infobaleen SaaS platform.

Flutter: A Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.


mOAuth: a basic OAuth 2.0 client/server implementation that is geared towards testing and development of OAuth-based services. The client library supports authorization of native macOS, iOS, and Linux applications with PKCE.

LibrePCB: A free EDA software to draw schematics and design printed circuit boards (PCBs).