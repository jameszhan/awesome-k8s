
```bash
$ ./k8s upgrade 192.168.64.21 ubuntu --version=v1.23.5
$ ./k8s upgrade 192.168.64.22 ubuntu --version=v1.23.5
$ ./k8s upgrade 192.168.64.23 ubuntu --version=v1.23.5

$ multipass restart k8s-node01
$ multipass restart k8s-node02
$ multipass restart k8s-node03

$ KUBECONFIG=/opt/etc/kube/config kubectl get nodes -o wide
$ KUBECONFIG=/opt/etc/kube/config kubectl version
```

```bash
$ for i in 1 2 3; do ./k8s upgrade k8s-master0$i james --version=v1.23.5; done
$ for i in 1 2 3; do ./k8s versions k8s-master0$i james; done

$ ansible -m shell -a "/opt/bin/update-system.sh" -v master
$ ansible -m reboot --become -v master

$ for i in 1 2 3 4 5 6 7 8 9; do ./k8s upgrade k8s-node00$i deploy --version=v1.23.5; done
$ for i in 1 2 3 4 5 6 7 8 9; do ./k8s versions k8s-node00$i deploy; done
$ for i in 1 2 3 5 6 7; do ./k8s upgrade k8s-node01$i deploy --version=v1.23.5; done
$ for i in 1 2 3 5 6 7; do ./k8s versions k8s-node01$i deploy; done

$ ansible -m shell -a "/opt/bin/update-system.sh" -u deploy -v worker
$ ansible -m reboot --become -u deploy -v worker
```