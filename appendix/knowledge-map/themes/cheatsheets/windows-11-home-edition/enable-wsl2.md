
[wsl2-install](https://aka.ms/wsl2-install)

```bat
wsl --update --pre-release
```

[wslstore](https://aka.ms/wslstore)

```bat
wsl --set-default-version 2
wsl --install -d Ubuntu-22.04
```


## 附录

#### 错误一：Error Code: 0x8007019e

WslRegisterDistribution failed with error: 0x8007019e


解决方法：

```bash
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```