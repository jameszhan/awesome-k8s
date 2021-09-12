#### KVM
KVM（Kernel-based Virtual Machine，基于内核的虚拟机）是一个开源的系统虚拟化模块，从Linux 2.6.20之后集成在Linux的各个主要发行版本中。它使用Linux自身的调度器进行管理，KVM的核心源码很少，这使它成为学术界的主流VMM之一。KVM的虚拟化与OpenVZ不同，它需要硬件支持（如Intel VT技术或者AMD V技术），是基于硬件的完全虚拟化。

KVM是Linux下x86硬件平台上的全功能虚拟化解决方案，它包含一个可加载的内核模块kvm.ko，提供了虚拟化核心架构和处理器规范模块。KVM虚拟化技术允许运行多种不同类型的虚拟机，包括Linux和Windows操作系统。完全虚拟化技术的每个虚拟机都有私有的硬件，包括网卡、磁盘以及图形适配卡等。

#### OpenVZ
OpenVZ是开源软件，是基于Linux平台的操作系统级服务器虚拟化解决方案，它是基于Linux内核和作业系统的操作系统级虚拟化技术。OpenVZ允许在单个物理服务器上创建多个隔离的虚拟专用服务器，这些虚拟专用服务器称为VPS（Virtual Private Server）或虚拟环境（Virtual Environment，VE）。OpenVZ虚拟化以最大效率共享硬件和管理资源。每个虚拟服务器的运行和独立服务器完全一致，

OpenVZ提供了独立的根访问权限、用户、内存、处理器、IP地址、文件、应用服务、系统库文件和配置文件等。对于用户进程、应用程序都可以独立进行维护，同时，OpenVZ软件也为用户提供了协助自动化管理虚拟服务器的工具，通过基于模板的应用程序部署方式，可以在几分钟内创建新的虚拟服务器并投入使用。与硬件虚拟化的VMware和半虚拟化的Xen相比，OpenVZ虚拟化技术中的host OS和guest OS都必须是Linux，这是出于对性能的考虑。根据OpenVZ网站的说法，使用OpenVZ与使用独立的服务器相比，性能只会有1%～3%的损失。这个特点可以让OpenVZ充分利用硬件资源，最大限度地发挥服务器虚拟化技术的优势

#### PVE
[Proxmox VE (Proxmox Virtual Environment)](https://www.proxmox.com/)是一个虚拟化集成应用平台。

Proxmox VE (Proxmox Virtual Environment) 是一个虚拟化集成应用平台。它提供了一个可运行OpenVZ和KVM的开源虚拟化平台，有方便易用的WEB界面、基于Java的UI和内核接口，用户可以很方便地登录VM进行操作。此外，Proxmox VE还有简单、易用的模板功能，基于模板的应用程序部署，可以在几分钟内用简单的方法创建新的虚拟服务器并投入使用，极大降低了服务器的安装和部署成本。

Proxmox VE是一个基于Debian Etch（x86_64)）版本的虚拟环境，因此不能把它安装到一个i386系统上。同时，如果要使用的是KVM，首先操作系统的CPU必须支持类似于Intel VT或者AMD-V的硬件虚拟化技术，然后还需要在主机BIOS里面将VT-X或VT-D选项打开才能真正使用。而如果仅仅使用OpenVZ，就不需要CPU的虚拟化支持了。

#### Vagrant
`Vagrant`是为了方便实现虚拟化环境而设计的，使用`Ruby`开发，基于`VirtualBox`等虚拟机管理软件的接口，提供了一个可配置、轻量级的便携式虚拟开发环境。
使用`Vagrant`可以很便捷地建立起一个虚拟环境，而且可以模拟多台虚拟机，这样我们平时还可以开发机模拟分布式系统。

https://app.vagrantup.com/boxes/search?order=desc&page=1&sort=downloads

```bash
$ vagrant box add ubuntu2004 ubuntu-20.04-amd64.box
$ vagrant init ubuntu2004 
$ vagrant up
```

```bash
# 显示当前已经添加的box列表：
$ vagrant box list

# 删除相应的box：
$ vagrant box remove

# 停止当前正在运行的虚拟机并销毁所有创建的资源：
$ vagrant destroy

# 跟操作真实机器一样，关闭虚拟机器：
# vagrant halt

# 打包命令，可以把当前运行的虚拟机环境进行打包：
$ vagrant package

# 重新启动虚拟机，主要用于重新载入配置文件：
$ vagrant reload

# 输出用于SSH连接的一些信息：
$ vagrant ssh-config

# 挂起当前的虚拟机：
$ vagrant suspend

# 恢复前面被挂起的状态：
$ vagrant resume

# 获取当前虚拟机的状态。
$ vagrant status
```

```ruby
Vagrant.configure("2") do |config|
    config.vm.define  "server" do |vb|        
        config.vm.provider "virtualbox" do |v|            
            v.memory = 512            
            v.cpus = 4        
        end        
        vb.vm.host_name = "server"
        vb.vm.network :public_network, ip: "10.0.0.15"        
        vb.vm.box = "ubuntu2004"    
    end

    config.vm.define  "vagrant1" do |vb|        
        config.vm.provider "virtualbox" do |v|            
            v.memory = 512            
            v.cpus = 4        
        end        
        vb.vm.host_name = "vagrant1"        
        vb.vm.network :public_network, ip: "10.0.0.16"        
        vb.vm.box = "ubuntu2004"    
    end

    config.vm.define  "vagrant2" do |vb|        
        config.vm.provider "virtualbox" do |v|            
            v.memory = 512            
            v.cpus = 4        
        end        
        vb.vm.host_name = "vagrant2"        
        vb.vm.network :public_network, ip: "10.0.0.17"        
        vb.vm.box = "ubuntu2004"    
    end
end
```