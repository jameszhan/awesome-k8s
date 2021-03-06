* Documentation:  https://help.ubuntu.com
* Management:     https://landscape.canonical.com
* Support:        https://ubuntu.com/advantage


### Ubuntu 常见工具

- juju: [Juju](https://juju.is/)
    - Juju 是一个 Charmed Operator 框架，由 Charmed Operator Lifecycle Manager 和 Charmed Operator SDK 组成。跨混合云无缝部署、集成和管理 Kubernetes、容器和 VM 原生应用程序。

## Ubuntu相关生态

#### [Canonical](https://canonical.com/)

#### [MicroK8s](https://microk8s.io/)
Low-touch Kubernetes for micro clouds, thin edge and IoT

#### [Landscape](https://landscape.canonical.com/)
Landscape is the leading management tool to deploy, monitor and manage your Ubuntu servers.

#### [Multipass](https://multipass.run/)
Multipass uses Hyper-V on Windows, HyperKit on macOS and KVM on Linux for minimal overhead and the fastest possible start time.

#### [Juju](https://jaas.ai/)

#### [MAAS](https://maas.io/)
Very fast server provisioning for your data centre

#### [snapcraft](https://snapcraft.io/)
The app store for Linux

#### [Kubernetes](https://ubuntu.com/kubernetes)

#### [OpenStack](https://ubuntu.com/openstack)
Multi–cloud operations are more cost-effective with a private cloud. Private cloud is more cost–effective with Canonical’s Charmed OpenStack.

#### [cloud-init](https://cloud-init.io/)

Cloud images are operating system templates and every instance starts out as an identical clone of every other instance. It is the user data that gives every cloud instance its personality and cloud-init is the tool that applies user data to your instances automatically.

##### Use `cloud-init` to configure:
- Setting a default locale 
- Setting the hostname 
- Generating and setting up SSH private keys 
- Setting up ephemeral mount points

#### `Ubuntu`将软件仓库分成如下几类。

- `main`: `Ubuntu`团队积极支持的、完全遵循自由软件版权协议的软件(除了一些二进制固件和字体以外)。
- `restricted`: 受限软件，虽然没有完全遵循自由软件版权协议，但在某些机器上是必需的，例如显卡制造商发行的二进制驱动。`Ubuntu`团队正努力促使这些制造商加速这些软件的开源，以保证尽可能多的软件符合自由软件版权协议。
- `universe`: 来自`Linux`世界的各种开源软件，`Canoical`公司不保证为它们提供定期的安全更新。其中一部分流行的或者支持良好的软件将会移入`main`库。
- `multiverse`: 多元化的、不满足`main`类版权协议的软件，有可能包含非自由软件或依赖非自由软件

![APT命令详解](images/apt-sub-commands.jpg)

### Ubuntu 常见工具

- juju: [Juju](https://juju.is/)
    - Juju 是一个 Charmed Operator 框架，由 Charmed Operator Lifecycle Manager 和 Charmed Operator SDK 组成。跨混合云无缝部署、集成和管理 Kubernetes、容器和 VM 原生应用程序。

### 附录

#### 资源地址
- [Ubuntu Cloud Images](http://cloud-images.ubuntu.com/)