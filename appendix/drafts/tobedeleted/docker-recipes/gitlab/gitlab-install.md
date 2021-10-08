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
    gitlab/gitlab-ce:latest

$ sudo docker logs -f gitlab
```

#### 配置GitLab

GitLab容器版本使用官方Omnibus发行版，所有配置都存在`/etc/gitlab/gitlab.rb`文件中。如果要修改该文件，可以进入容器再修改：

```bash
$ sudo docker exec -it gitlab vi /etc/gitlab/gitlab.rb
$ sudo docker restart gitlab
$ sudo docker logs -f gitlab
```

#### 升级GitLab

GitLab的版本一直持续更新，这也是作者在使用过程中最担心的问题。每次升级都要做好备份，然后升级测试，待一切稳定后才能放心。而通过`Docker`升级则非常方便。

```bash
# 停止现有的容器
$ sudo docker stop gitlab
# 删除现有容器
$ sudo docker rm gitlab

# 获取最新版本Gitlab镜像
$ sudo docker pull gitlab/gitlab-ce

# 再次运行GitLab命令
$ sudo docker run --detach \
    --hostname git.zizhizhan.com --publish 443:443 --publish 80:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume /opt/var/gitlab/config:/etc/gitlab \
    --volume /opt/var/gitlab/logs:/var/log/gitlab \
    --volume /opt/var/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest

$ sudo docker exec -it gitlab bash
```

```bash
$ gitlab-rails console
> User.all.each{ |u| User.column_names.collect{|un| puts "#{un}: #{u[un]}" } }

> user = User.find(1)
> user = User.where(username: 'root').first
> user.password = 'git@zizhizhan.com'
> user.password_confirmation = 'git@zizhizhan.com'
> user.save!
```



```bash
$ /opt/gitlab/bin/gitlab-psql -d template1 -c "CREATE USER \"gitlab\""
$ /opt/gitlab/bin/gitlab-psql -d template1 -c "CREATE USER \"gitlab\""

```


```bash
$ curl -X GET \
    -H "Content-Type: application/json" \
    -i http://git.zizhizhan.com/sidekiq
```


```bash

$ sudo docker exec -it gitlab cat /opt/gitlab/embedded/service/gitlab-rails/db/fixtures/production/002_admin.rb
```