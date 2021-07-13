##### CirrOS

> `CirrOS`是设计用来进行云计算环境测试的`Linux`微型发行版，它拥有HTTP客户端工具`curl`等。

```bash
$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
# 或
$ docker run -it --rm cirros sh
```


```bash
$ curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" http://ws.zizhizhan.local/ws/
```
