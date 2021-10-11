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

[Discover Vagrant Boxes](https://app.vagrantup.com/boxes/search?order=desc&page=1&sort=downloads)
