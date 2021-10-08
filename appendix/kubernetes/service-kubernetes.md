
> 当我们部署好一个`k8s`集群之后，系统会自动在`default namespace`下创建一个`name`为`kubernetes`的`service`。
> `kubernetes service`的`ip`是`--service-cluster-ip-range`的第一个`IP`，并且该`service`没有设置`spec.selector`。理论上来说，对于没有设置`selector`的`service`，`kube-controller-manager`不会自动创建同名的`endpoints`资源出来。

```bash
$ kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   192.168.1.129   <none>        443/TCP   19h

# 基于 iptables
$ sudo iptables -t nat -nL
Chain KUBE-SERVICES (2 references)
target                     prot opt source               destination
KUBE-MARK-MASQ             tcp  -- !10.244.0.0/16        10.96.0.1            /* default/kubernetes:https cluster IP */ tcp dpt:443
KUBE-SVC-NPX46M4PTMTKRN6Y  tcp  --  0.0.0.0/0            10.96.0.1            /* default/kubernetes:https cluster IP */ tcp dpt:443

Chain KUBE-SVC-NPX46M4PTMTKRN6Y (1 references)
target                     prot opt source               destination
KUBE-SEP-X6HPDLIIYVJMK7OF  all  --  0.0.0.0/0            0.0.0.0/0            /* default/kubernetes:https */

# 基于 ipvs
$ sudo ipvsadm -Ln
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.1.129:443 rr
  -> 192.168.1.61:6443            Masq    1      1          0
  -> 192.168.1.62:6443            Masq    1      2          0
  -> 192.168.1.63:6443            Masq    1      1          0
```

```bash
$ kubectl get svc kubernetes -o yaml
$ kubectl get ep kubernetes -o yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    component: apiserver
    provider: kubernetes
  name: kubernetes
  namespace: default
spec:
  clusterIP: 192.168.1.129
  clusterIPs:
  - 192.168.1.129
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: https
    port: 443
    protocol: TCP
    targetPort: 6443
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
```

```yaml
apiVersion: v1
kind: Endpoints
metadata:
  labels:
    endpointslice.kubernetes.io/skip-mirror: "true"
  name: kubernetes
  namespace: default
subsets:
- addresses:
  - ip: 192.168.1.61
  - ip: 192.168.1.62
  - ip: 192.168.1.63
  ports:
  - name: https
    port: 6443
    protocol: TCP
```