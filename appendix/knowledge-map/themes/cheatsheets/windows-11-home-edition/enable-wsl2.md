## Install WSL2

[wsl2-install](https://aka.ms/wsl2-install)

```bat
wsl --update --pre-release
```

[wslstore](https://aka.ms/wslstore)

```bat
wsl --set-default-version 2
wsl --install -d Ubuntu-22.04

wsl -l -v
```

## Config Linux

```bash
# 配置`sudo`免密
$ echo 'james ALL = (ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/james > /dev/null

# 设置时区和本地化
$ sudo timedatectl set-timezone Asia/Shanghai
$ sudo dpkg-reconfigure locales
# sudo localectl set-locale LANG=zh_CN.utf8
$ sudo localectl set-locale LANG=en_US.utf8
```

#### `WSL2`迁移虚拟机到指定位置

```bash
wsl -l --all -v

# 导出分发版为tar文件到d盘
wsl --export Ubuntu-22.04 d:\wsl\distros\Ubuntu-22.04.tar

# 注销当前分发版
wsl --unregister Ubuntu-22.04

# 重新导入并安装WSL在D盘
wsl --import Ubuntu-22.04 d:\wsl\distros\Ubuntu-22.04 d:\wsl\distros\Ubuntu-22.04.tar --version 2

# 设置默认登陆用户为安装时用户名
ubuntu2204 config --default-user james

# 删除Ubuntu-22.04.tar
del d:\wsl\distros\Ubuntu-22.04.tar
```



## 附录

#### 错误一：Error Code: 0x8007019e

WslRegisterDistribution failed with error: 0x8007019e


解决方法：

```bash
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```