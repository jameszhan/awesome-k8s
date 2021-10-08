

```bash
$ sudo iptables -t nat -nL

$ sudo ipvsadm -Ln

$ $ ansible -i hosts all -m shell -a "ipvsadm -Ln" -u deploy --become -v

$ nc -vz 192.168.1.129 443
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.129/version
```

```bash
$ ansible -m script -a 'scripts/kubernetes-service.sh' -i hosts all -u deploy --become -v
$ ansible -m script -a 'scripts/iptables-reset.sh' -i hosts all -u deploy --become -v
```