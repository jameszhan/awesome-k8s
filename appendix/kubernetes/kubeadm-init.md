
```bash
$ kubeadm init phase
Use this command to invoke single phase of the init workflow

Usage:
  kubeadm init phase [command]
  
Available Commands:
  addon              Install required addons for passing conformance tests
  bootstrap-token    Generates bootstrap tokens used to join a node to a cluster
  certs              Certificate generation
  control-plane      Generate all static Pod manifest files necessary to establish the control plane
  etcd               Generate static Pod manifest file for local etcd
  kubeconfig         Generate all kubeconfig files necessary to establish the control plane and the admin kubeconfig file
  kubelet-finalize   Updates settings relevant to the kubelet after TLS bootstrap
  kubelet-start      Write kubelet settings and (re)start the kubelet
  mark-control-plane Mark a node as a control-plane
  preflight          Run pre-flight checks
  upload-certs       Upload certificates to kubeadm-certs
  upload-config      Upload the kubeadm and kubelet configuration to a ConfigMap
  
```

#### `kubeadm config print init-defaults`
```yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
localAPIEndpoint:
  advertiseAddress: 1.2.3.4
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  imagePullPolicy: IfNotPresent
  name: node
  taints: null
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
apiServer:
  timeoutForControlPlane: 4m0s
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: k8s.gcr.io
kubernetesVersion: 1.22.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}
```

#### `kubeadm init`流程

- `preflight`                    预置检查
- `kubelet-start`                生成`kubelet`配置，并重启`kubelet`
- `certs`                        生成认证
  - `/etcd-ca`                   生成自签名`CA`以为`etcd`配置标识
  - `/apiserver-etcd-client`     生成`apiserver`用于访问`etcd`的证书
  - `/etcd-healthcheck-client`   生成`liveness`探针使用的证书，用于检查`etcd`的`healtcheck`状态
  - `/etcd-server`               生成`etcd`服务使用的的证书
  - `/etcd-peer`                 为`etcd`节点生成证书以相互通信
  - `/ca`                        生成自签名的`Kubernetes CA`，为其他`Kubernetes`组件预配标识
  - `/apiserver`                 生成用于提供`Kubernetes API`的证书`api server`端证书
  - `/apiserver-kubelet-client`  为`API`服务器生成证书以连接到`kubelet`
  - `/front-proxy-ca`            生成自签名`CA`以预配`front proxy`标识
  - `/front-proxy-client`        为前端代理客户端生成证书
  - `/sa`                        生成用于对服务帐户令牌及其公钥进行签名的私钥
- `kubeconfig`                   生成`control plane`和`admin`管理员相关的`kubeconfig`文件
  - `/admin`                     生成`admin`管理员和`kubeadm`自身使用的`kubeconfig`文件
  - `/kubelet`                   生成`kebelet`使用的，仅用于引导集群`(bootstrap)`的`kubeconfig`文件
  - `/controller-manager`        生成`controller manager`使用的`kubeconfig`文件
  - `/scheduler`                 生成`scheduler`使用的`kubeconfig`文件
- `kubelet-start`                生成`kubelet`的环境变量文件`/var/lib/kubelet/kubeadm-flags.env`和配置信息文件`/var/lib/kubelet/config.yaml`，然后`启动/重启 kubelet(systemd 模式)`
- `control-plane`                生成拉起`control plane (master) static Pod`的`manifest`文件
  - `/apiserver`                 生成拉起`kube-apiserver`的`static Pod manifest`
  - `/controller-manager`        生成拉起`kube-controller-manager`的`static Pod manifest`
  - `/scheduler`                 生成拉起`kube-scheduler`的`static Pod manifest`
- `etcd`                         生成本地`ETCD`的`static Pod manifest`文件
  - `/local`                     生成单节点本地`ETCD static Pod manifest`文件
- `upload-config`                上传`kubeadm`和`kubelet`配置为`ConfigMap`
  - `/kubeadm`                   上传`kubeadm ClusterConfiguration`为`ConfigMap`
  - `/kubelet`                   上传`kubelet component config`为`ConfigMap`
- `upload-certs`                 上传证书到`kubeadm-certs`
- `mark-control-plane`           标识节点为`control-plane`
- `bootstrap-token`              生成`bootstrap tokens`用于其他节点加入集群
- `addon`                        安装所需的插件以通过一致性测试
  - `/coredns`                   安装`CoreDNS`插件
  - `/kube-proxy`                安装`kube-proxy`插件

`kubeadm init`通过执行以下步骤来引导`Kubernetes`控制平面节点：
1. 在进行更改之前运行一系列飞行前检查以验证系统状态。某些检查仅触发警告，其他检查被视为错误，并将退出`kubeadm`，直到问题得到纠正或用户指定`--ignore-preflight-errors=<list-of-errors>`。 来忽略错误。
2. 生成自签名`CA`(或使用现有CA)，以便为群集中的每个组件设置标识。如果用户通过将其放在通过`--cert-dir`配置的`cert`目录(默认情况下为`/etc/kubernetes/pki`)中提供了自己的`CA证书`和密钥，则会跳过此步骤，如使用自定义证书文档中所述。`APIServer`证书将`--apiserver-cert-extra-sans`参数提供的额外`SAN`条目添加到证书信息中，如果需要，可以小写。
3. 在`/etc/kubernetes/`中为`kubelet`，`controller-manager`和`scheduler`写入`kubeconfig`文件，用于连接到`API`服务器，每个都有自己的标识，以及另一个名为`admin.conf`的管理员`kubeconfig`文件。
4. 生成启动`kubelet`服务所需的配置文件和环境变量，并启动`kubelet`(systemd方式)生成文件如下：
   - `/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf` 环境变量
   - `/etc/kubernetes/bootstrap-kubelet.conf`
   - `/etc/kubernetes/kubelet.conf`
   - `/var/lib/kubelet/config.yaml`
- `/var/lib/kubelet/kubeadm-flags.env` 环境变量
    ```bash
    $ systemctl status kubelet
    ● kubelet.service - kubelet: The Kubernetes Node Agent
    Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/kubelet.service.d
    └─10-kubeadm.conf
    Active: active (running) since Fri 2021-10-01 22:32:21 CST; 4 days ago
    Docs: https://kubernetes.io/docs/home/
    Main PID: 235247 (kubelet)
    Tasks: 16 (limit: 4654)
    Memory: 94.8M
    CGroup: /system.slice/kubelet.service
    └─235247 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --network-plugin=cni --pod-infra-container-image=k8s.gcr.io/pause:3.4.1
    ```
5. 为`apiserver`，`control-manager`和`scheduler`生成静态`Pod`清单。 
    > 如果未提供外部`etcd`，则会为`etcd`生成其他静态`Pod`清单。 `Static Pod`清单写入`/etc/kubernetes/manifests`; `kubelet`监视此目录以便`Pods`在启动时创建。
    > `control plane`的`pod`启动后，`init`开始继续执行后面的流程。
    - 将`label`和`taint`应用于控制平面节点，以便不会在那里运行其他工作负载。
    - 生成其他节点将来可用于向控件平面注册自己的令牌。或者，用户可以通过`--token`参数来指定一个令牌。具体在`kubeadm token`文档中。
    - 进行所有必要的配置，以允许其他节点通过引导令牌`bootstrap token`和`TLS boostrap`机制进行加入
        - 写入加入集群的所需的信息到`configmap`，设置相关的`RBAC`规则。
        - 让`bootstrap token`访问`CSR`(证书签名请求)签名`API`。
        - `Configure auto-approval for new CSR requests`. 对`CSR`请求(证书签名请求)配置自动同意。

