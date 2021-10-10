```bash
$ virsh autostart --disable manager-node
$ virsh autostart --disable master-node
$ virsh autostart --disable slave-node

$ virsh shutdown slave-node
$ virsh domrename slave-node k8s-node029

$ virsh edit k8s-node029
$ virsh start k8s-node029

$ virsh autostart master-server 
$ virsh autostart manager-server
$ virsh autostart proxy-server  
$ virsh autostart slave-server

$ virsh autostart manager-node
$ virsh autostart slave-node  
$ virsh autostart master-node

$ virsh autostart k8s-node10
$ virsh autostart k8s-node11
```