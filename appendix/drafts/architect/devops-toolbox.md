#### `Ansible`

#### `Fabric`

##### `Fabric`在性能方面的不足
> `Fabric`的底层设计是基于`Python`的`paramiko`基础库的，它并不支持原生的`OpenSSH`，原生的`OpenSSH`的`Multiplexing`及`pipeline`的很多特性都不支持，而这些通过优化都能极大地提升性能。相对而言，`Fabric`适合集群内的自动化运维方案(集群内机器数量不多)，如果机器数量多，可以考虑`Ansible`。

#### `mussh`
> 全称是`Multihost SSH Wrapper`，它其实是一个`SSH`封装器，由一个`shell`脚本实现。通过`mussh`可以实现批量管理多台远程主机的功能。