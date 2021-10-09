#### Add deploy User

```bash
$ cd install-binaries/ansible

$ ansible-playbook -i hosts -l k8s_new_nodes --list-hosts user-deploy.yml
$ ansible-playbook -i hosts -l k8s_new_nodes -c paramiko --ask-pass --ask-become-pass user-deploy.yml -v

# 测试新增用户效果
$ ansible -i hosts k8s_new_nodes -m ping -u deploy
```

#### Sanitize the Worker Node

```bash
$ cd install-binaries/ansible

$ ansible -m shell -a "rm -vrf /var/log/journal" -i hosts k8s_new_nodes -u deploy --become -v
$ ansible -m script -a 'cleaner/clean-setup-once.sh' -i hosts k8s_new_nodes -u deploy --become -v

$ ansible -m script -a 'cleaner/clean-k8s-node.sh' -i hosts k8s_new_nodes -u deploy --become -v
$ ansible -m script -a 'cleaner/clean-docker.sh' -i hosts k8s_new_nodes -u deploy --become -v

$ ansible -i hosts k8s_new_nodes -m reboot -u deploy --become -v
```

#### Install Worker Component

```bash
$ ansible-playbook -i hosts -l k8s_new_nodes setup-once.yml -u deploy -v

$ cd ../../debian-based/ansible && ansible-playbook -i hosts -l k8s_new_nodes docker.yml -u deploy -v && cd ../../install-binaries/ansible

$ ansible -i hosts k8s_new_nodes -m reboot -u deploy --become -v
$ ansible -i hosts k8s_new_nodes -m shell -a "docker ps" -u deploy --become -v

$ ansible-playbook -i hosts -l k8s_new_nodes k8s-node.yml -u deploy -v
$ ansible -i hosts k8s_new_nodes -m shell -a "systemctl status kubelet" -u deploy --become -v
$ ansible -i hosts k8s_new_nodes -m shell -a "systemctl status kube-proxy" -u deploy --become -v
$ ansible -i hosts k8s_new_nodes -m reboot -u deploy --become -v
```

Accept New Nodes

```bash
$ kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve

$ kubectl get nodes -o wide
```