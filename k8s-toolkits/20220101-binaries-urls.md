

#### `k8s`二进制文件

查看最新`k8s`发布版本

```bash
$ curl -L -s https://dl.k8s.io/release/stable.txt
```

> 下载不同版本的`K8S`安装文件，参考: [get-kube-binaries.sh](https://github.com/kubernetes/kubernetes/blob/master/cluster/get-kube-binaries.sh)

```bash
$ wget https://storage.googleapis.com/kubernetes-release/release/v1.23.3/kubernetes-server-linux-amd64.tar.gz
$ wget https://storage.googleapis.com/kubernetes-release/release/v1.23.3/kubernetes-server-linux-arm64.tar.gz
```

#### `kubectl`

```bash
# Intel
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"

# Apple Silicon
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
```

#### `Helm`

```bash
$ curl -LO https://get.helm.sh/helm-v3.8.0-linux-arm64.tar.gz
```

[Download Kubernetes](https://www.downloadkubernetes.com/): An easier way to get the binaries you need (or a link to them)
