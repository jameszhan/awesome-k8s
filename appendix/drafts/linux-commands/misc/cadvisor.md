

```bash
$ docker pull google/cadvisor

$ docker run \
  --volume=/var/run:/var/run:rw \
  --volume=/sys/fs/cgroup/:/sys/fs/cgroup:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --detach=true \
  google/cadvisor

$ curl -i http://192.168.1.95:8080
```