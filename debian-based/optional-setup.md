#### 删除 snap 服务

```bash
$ snap list | awk '{print $1}' | grep -v Name | sort | xargs -i sudo snap remove {}
$ sudo apt autoremove --purge snapd
```

#### 取消自动更新

```bash
$ sudo apt -y purge unattended-upgrades
$ sudo apt -y autoremove
```