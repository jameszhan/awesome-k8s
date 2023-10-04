# Install Vagrant with Hyper-V

Vagrant 是一个用于创建和配置轻量级、可重复使用和便携式的开发环境的工具。Vagrant 可以在 Windows 下使用，并且支持多种虚拟化解决方案，包括 VirtualBox、VMware 和 Hyper-V。

## Install Vagrant

### 下载并安装Vagrant

你可以从 Vagrant 的[官方网站](https://developer.hashicorp.com/vagrant)下载 [Windows 版的 Vagrant](https://releases.hashicorp.com/vagrant/2.3.7/vagrant_2.3.7_windows_amd64.msi)，并进行安装。

验证安装结果

```powershell
$ vagrant version
Installed Version: 2.3.7
Latest Version: 2.3.7

$ vagrant global-status
```

### 启用 Hyper-V

要使用 Hyper-V，你需要确保它已经在你的 Windows 操作系统上启用。你可以通过 Windows 功能的设置来启用 Hyper-V。

### 设置 Vagrant

当你创建一个新的`Vagrant`项目或启动一个现有的`Vagrant`项目时，你可以指定使用`Hyper-V`作为提供者。例如：
   
```powershell
$ vagrant up --provider=hyperv
```

### 注意事项
   
- `Hyper-V`和`VirtualBox`不能同时运行。如果你已经在使用`VirtualBox`，那么在启动使用`Hyper-V`的`Vagrant`项目时可能会遇到问题。你可能需要禁用其中一个虚拟化解决方案。
- 使用`Hyper-V`时，`Vagrant`需要管理员权限来创建和管理虚拟机。确保你有足够的权限或以管理员身份运行命令提示符或`PowerShell`。
- 不是所有的`Vagrant`盒子都与`Hyper-V`兼容。确保你选择的盒子支持`Hyper-V`。

## Vagrant Cheatsheet
   
- 初始化新的 Vagrant 项目：`vagrant init`
- 启动虚拟机：`vagrant up`
- SSH 连接到虚拟机（如果是 Linux 盒子）：`vagrant ssh`
- 销毁虚拟机：`vagrant destroy`
- 挂起虚拟机：`vagrant suspend`
- 重新启动虚拟机：`vagrant reload`

## 配置 Vagrantfile

为了充分利用`Hyper-V`，你可能需要在你的`Vagrantfile`中进行一些特定的配置，如设置网络、选择合适的盒子等。

```powershell
$ vagrant init
```

