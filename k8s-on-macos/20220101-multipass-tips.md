

#### 安装和卸载

```bash
$ brew install --cask multipass

# to destroy all data, too
$ brew uninstall --zap multipass
```

#### 查看默认配置

```bash
$ multipass help get

$ multipass get client.gui.autostart
$ multipass get client.gui.hotkey
$ multipass get client.primary-name

$ sudo multipass get local.bridged-network
$ sudo multipass get local.privileged-mounts
$ sudo multipass get local.driver
```