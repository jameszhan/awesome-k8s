#### 命令示例

```bash
# 显示系统状态
$ systemctl status

# 显示单个 Unit 的状态
$ systemctl status rsync.service
$ systemctl status cron.service
$ systemctl status ssh.service
$ systemctl status dbus.service
$ systemctl status systemd-networkd.service

# 显示某个 Unit 的所有底层参数
$ systemctl show dbus.service
$ systemctl show ssh.service

#  查询缺失的服务
$ systemctl --state=not-found --all
```

#### 典型的`systemctl`命令片段列表

| 操作                                         | 命令片段                                        |
| -------------------------------------------- | ----------------------------------------------- |
| 列出所有单元配置类型                         | `systemctl list-units --type=help`              |
| 列出所有`target`单元配置                     | `systemctl list-units --type=target`            |
| 列出所有`service`单元配置                    | `systemctl list-units --type=service`           |
| 列出内存中所有`socket`单元                   | `systemctl list-sockets`                        |
| 列出内存中所有`timer`单元                    | `systemctl list-timers`                         |
| 启动`$unit`                                  | `systemctl start $unit`                         |
| 停止`$unit`                                  | `systemctl stop $unit`                          |
| 停止和启动`$unit`                           | `systemctl restart $unit`                       |
| 重新加载服务相关的配置                       | `systemctl reload $unit`                        |
| 启动`$unit`并停止所有其它的                  | `systemctl isolate $unit`                       |
| 转换到`图形`(图形界面系统)                   | `systemctl isolate graphical`                   |
| 转换到`多用户`(命令行系统)                   | `systemctl isolate multi-user`                  |
| 转换到`应急模式`(单用户命令行系统)           | `systemctl isolate rescue`                      |
| 向`$unit`发送杀死信号                        | `systemctl kill $unit`                          |
| 检查`$unit`服务是否是活动的                  | `systemctl is-active $unit`                     |
| 检查`$unit`服务是否是失败的                  | `systemctl is-failed $unit`                     |
| 检查`$unit|$PID|$device`的状态             | `systemctl status $unit|$PID|$device` |
| 显示`$unit|$job`的属性                     | `systemctl show $unit|$job`                |
| 重设失败的`$unit`                            | `systemctl reset-failed $unit`                  |
| 列出所有单元服务的依赖性                     | `systemctl list-dependencies --all`             |
| 列出安装在系统上的单元文件                   | `systemctl list-unit-files`                     |
| 启用`$unit`(增加符号链接)                    | `systemctl enable $unit`                        |
| 禁用`$unit`(删除符号链接)                    | `systemctl disable $unit`                       |
| 取消遮掩`$unit`(删除到`/dev/null`的符号链接) | `systemctl unmask $unit`                        |
| 遮掩`$unit`(增加到`/dev/null`的符号 链接)    | `systemctl mask $unit`                          |
| 获取默认的`target`设置                       | `systemctl get-default`                         |
| 设置默认`target`为`graphical`(图形系统)      | `systemctl set-default graphical`               |
| 设置默认`target`为`multi-user`(命令行系统)   | `systemctl set-default multi-user`              |
| 显示工作环境变量                             | `systemctl show-environment`                    |
| 设置环境变量`variable`的值为`value`          | `systemctl set-environment variable=value`      |
| 取消环境变量`variable`的设置                 | `systemctl unset-environment variable`          |
| 重新加载所有单元文件和后台守护进程(daemon)   | `systemctl daemon-reload`                       |
| 关闭系统                                     | `systemctl poweroff`                            |
| 关闭和重启系统                               | `systemctl reboot`                              |
| 挂起系统                                     | `systemctl suspend`                             |
| 休眠系统                                     | `systemctl hibernate`                           |

#### 其它系统监控

| 操作                              | 命令片段                                 |
| --------------------------------- | -------------------------------------- |
| 显示每一个初始化步骤所消耗的时间       | `systemd-analyze time`                 |
| 列出所有单元的初始化时间              | `systemd-analyze blame`                |
| 加载`$unit`文件并检测错误            | `systemd-analyze verify $unit`         |
| 简洁的显示用户调用会话的运行时状态信息  | `loginctl user-status`                  |
| 简洁的显示调用会话的运行时状态信息     | `loginctl session-status`               |
| 跟踪 cgroups 的启动过程             | `systemd-cgls`                          |
| 跟踪 cgroups 的启动过程             | `ps xawf -eo pid,user,cgroup,args`      |
| 跟踪 cgroups 的启动过程             | 读取`/sys/fs/cgroup/systemd/`下的`sysfs`  |

`systemctl status`命令用于查看系统状态和单个`Unit`的状态。

