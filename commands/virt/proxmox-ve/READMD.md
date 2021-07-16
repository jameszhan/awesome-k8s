
[Proxmox VE (Proxmox Virtual Environment)](https://www.proxmox.com/)是一个虚拟化集成应用平台。


Proxmox VE (Proxmox Virtual Environment) 是一个虚拟化集成应用平台。它提供了一个可运行OpenVZ和KVM的开源虚拟化平台，有方便易用的WEB界面、基于Java的UI和内核接口，用户可以很方便地登录VM进行操作。此外，Proxmox VE还有简单、易用的模板功能，基于模板的应用程序部署，可以在几分钟内用简单的方法创建新的虚拟服务器并投入使用，极大降低了服务器的安装和部署成本。

Proxmox VE是一个基于Debian Etch（x86_64)）版本的虚拟环境，因此不能把它安装到一个i386系统上。同时，如果要使用的是KVM，首先操作系统的CPU必须支持类似于Intel VT或者AMD-V的硬件虚拟化技术，然后还需要在主机BIOS里面将VT-X或VT-D选项打开才能真正使用。而如果仅仅使用OpenVZ，就不需要CPU的虚拟化支持了。