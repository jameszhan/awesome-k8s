

#### Kuboard

```bash
$ sudo docker run -d \
  --restart=unless-stopped \
  --name=kuboard \
  -p 80:80/tcp \
  -p 10081:10081/tcp \
  -e KUBOARD_ENDPOINT="http://192.168.1.118:80" \
  -e KUBOARD_AGENT_SERVER_TCP_PORT="10081" \
  -v /root/kuboard-data:/data \
  eipwork/kuboard:v3

$ kubectl delete -f https://addons.kuboard.cn/kuboard/kuboard-v3.yaml
$ kubectl apply -f https://addons.kuboard.cn/kuboard/kuboard-v3.yaml
```


- [Kuboard](https://kuboard.cn/)