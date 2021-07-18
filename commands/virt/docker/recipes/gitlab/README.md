```bash
docker run --detach \
    --hostname gitlab.james.me \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume /james/var/gitlab/config:/etc/gitlab \
    --volume /james/var/gitlab/logs:/var/log/gitlab \
    --volume /james/var/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```

login: root
password: 5iveL!fe