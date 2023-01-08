
```bash
$ ./k8s-upgrade k8s 192.168.1.61 deploy --version=v1.23.15
$ ./k8s-upgrade k8s 192.168.1.62 deploy --version=v1.23.15
$ ./k8s-upgrade k8s 192.168.1.63 deploy --version=v1.23.15

$ ./k8s-upgrade etcd 192.168.1.61 deploy --version=v3.5.6
$ ./k8s-upgrade etcd 192.168.1.62 deploy --version=v3.5.6
$ ./k8s-upgrade etcd 192.168.1.63 deploy --version=v3.5.6

$ ssh deploy@192.168.1.61 sudo reboot
$ ssh deploy@192.168.1.63 sudo reboot

$ kubectl version
$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/k8s/cfssl/etcd/ca.pem \
  --cert=/opt/etc/k8s/cfssl/etcd/etcd.pem \
  --key=/opt/etc/k8s/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint status

$ kubectl get nodes -o wide
```

```bash
$ for i in 1 2 3; do ./k8s-upgrade k8s k8s-master0$i deploy --version=v1.23.15; done
$ for i in 1 2 3; do ./k8s-upgrade versions k8s-master0$i deploy; done

$ ansible -m shell -a "/opt/bin/update-system.sh" -v master
$ ansible -m reboot --become -v master

$ for i in 1 2 3 5 6 7; do ./k8s-upgrade k8s k8s-node00$i deploy --version=v1.23.15; done
$ for i in 1 2 3 5 6 7; do ./k8s-upgrade versions k8s-node00$i deploy; done

$ ansible -m shell -a "/opt/bin/update-system.sh" -u deploy -v worker
$ ansible -m reboot --become -u deploy -v worker
```