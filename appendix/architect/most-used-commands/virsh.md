```bash
$ virsh autostart --disable manager-node
$ virsh autostart --disable master-node
$ virsh autostart --disable slave-node

$ virsh shutdown slave-node
$ virsh domrename slave-node k8s-node029

$ virsh edit k8s-node029
$ virsh start k8s-node029
```