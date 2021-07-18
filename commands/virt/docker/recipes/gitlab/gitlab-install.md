[GitLab cloud native Helm Chart](https://docs.gitlab.com/charts/)

### 使用 Docker 部署 GitLab

#### 准备文件目录

```bash
$ mkdir -p /opt/var/gitlab/{data,logs,config}
```

| 本地目录               | 容器目录        | 用途            |
| ---------------------- | --------------- | --------------- |
| /opt/var/gitlab/data   | /var/opt/gitlab | gitlab 数据     |
| /opt/var/gitlab/logs   | /var/log/gitlab | gitlab 日志     |
| /opt/var/gitlab/config | /etc/gitlab     | gitlab 配置文件 |

#### 启动GitLab镜像

```bash
$ sudo docker run --detach \
    --hostname git.zizhizhan.com --publish 443:443 --publish 80:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume /opt/var/gitlab/config:/etc/gitlab \
    --volume /opt/var/gitlab/logs:/var/log/gitlab \
    --volume /opt/var/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ee:latest

$ sudo docker logs -f gitlab
```

#### 配置GitLab

GitLab容器版本使用官方Omnibus发行版，所有配置都存在`/etc/gitlab/gitlab.rb`文件中。如果要修改该文件，可以进入容器再修改：

```bash
$ docker exec -it gitlab vi /etc/gitlab/gitlab.rb
$ docker restart gitlab
$ sudo docker logs -f gitlab
```

#### 升级GitLab

GitLab的版本一直持续更新，这也是作者在使用过程中最担心的问题。每次升级都要做好备份，然后升级测试，待一切稳定后才能放心。而通过`Docker`升级则非常方便。

```bash
# 停止现有的容器
$ docker stop gitlab
# 删除现有容器
$ docker rm gitlab

# 获取最新版本Gitlab镜像
$ docker pull gitlab/gitlab-ce

# 再次运行GitLab命令
$ docker run --detach \
    --hostname git.zizhizhan.com --publish 443:443 --publish 8081:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume /opt/var/gitlab/config:/etc/gitlab \
    --volume /opt/var/gitlab/logs:/var/log/gitlab:Z \
    --volume /opt/var/gitlab/data:/var/opt/gitlab:Z \
    gitlab/gitlab-ce:latest
```

sudo docker run --hostname git.zizhizhan.com --publish 443:443 --publish 8081:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume /opt/var/gitlab/config:/etc/gitlab \
    --volume /opt/var/gitlab/logs:/var/log/gitlab:Z \
    --volume /opt/var/gitlab/data:/var/opt/gitlab:Z \
    gitlab/gitlab-ce:latest



sudo docker run --detach \
    --hostname git.zizhizhan.com \
    --publish 443:443 --publish 80:80 --publish 22:2222 \
    --name gitlab \
    --restart always \
    --volume /opt/var/gitlab/config:/etc/gitlab \
    --volume /opt/var/gitlab/logs:/var/log/gitlab \
    --volume /opt/var/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ee:latest