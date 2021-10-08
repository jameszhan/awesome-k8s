

```bash

$ nc -vz 192.168.1.129 443
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.129/version
```

