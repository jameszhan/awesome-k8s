
#### 准备工作

```sql
REVOKE ALL ON *.* FROM 'pma'@'192.168.1.%';
DROP USER 'pma'@'192.168.1.%';

CREATE USER 'pma'@'192.168.1.%' IDENTIFIED BY 'pmapass';
GRANT ALL PRIVILEGES ON `phpmyadmin`.* TO 'pma'@'192.168.1.%' WITH GRANT OPTION;

GRANT SELECT ON *.* TO 'pma'@'192.168.1.%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.160' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.161' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.162' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.163' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.165' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.166' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.167' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.168' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.169' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
FLUSH PRIVILEGES;

SELECT Host, User, Password, authentication_string, is_role, default_role FROM mysql.user;
```

[create_tables.sql](https://github.com/phpmyadmin/phpmyadmin/blob/master/sql/create_tables.sql)

#### `Docker` 验证

```bash
$ sudo docker run -d --name local-pma --rm \
    -e PMA_HOST=10.255.2.55 \
    -e PMA_PORT=4000 \
    -e PMA_USER=pma \
    -e PMA_PASSWORD=password \
    -p 8080:80 phpmyadmin/phpmyadmin:4.8

$ curl -i http://localhost:8080
```

#### 部署`phpMyAdmin`

```bash
$ kubectl create configmap pma-config-inc -n geek-apps --from-file=config.inc.php=templates/phpmyadmin/pma.config.inc.php
$ kubectl get cm pma-config-inc -n geek-apps -o yaml

$ echo -n 'admin' > templates/secrets/pma-username.txt
$ echo -n '1f2d1e2e67df' > templates/secrets/pma-password.txt

$ kubectl delete secret pma-user-pass -n geek-apps
$ kubectl create secret -n geek-apps generic pma-user-pass \
  --from-file=PMA_CONTROLUSER=templates/secrets/pma-username.txt \
  --from-file=PMA_CONTROLPASS=templates/secrets/pma-password.txt

$ kubectl get secrets -n geek-apps
$ kubectl describe secrets/pma-user-pass -n geek-apps
$ kubectl get secret pma-user-pass -n geek-apps -o yaml

$ kubectl delete -f templates/phpmyadmin/pma-deploy.yml
$ kubectl apply -f templates/phpmyadmin/pma-deploy.yml
$ kubectl describe svc nginx-pma-service -n geek-apps

$ kubectl delete pod check-pma-config -n geek-apps
$ kubectl apply -f templates/phpmyadmin/check-pma-config.yaml
$ kubectl logs check-pma-config -n geek-apps

$ open https://pma.zizhizhan.com:8443
```





```bash
$ kubectl apply -f deploy/phpmyadmin.deployment.yaml
$ kubectl describe svc nginx-pma-service -n geek-apps

$ kubectl exec -it synology-phpmyadmin-5444d48c77-grxh6 -n geek-apps -- sh

$ kubectl proxy --port=8080
$ open http://localhost:8080/api/v1/proxy/namespaces/geek-apps/services/nginx-pma-service/
```

```bash
$ cd /usr/local/mariadb10/bin
$ cd /volume1/@appstore/MariaDB10/usr/local/mariadb10/bin

$ sudo netstat -plntu
$ sudo iptables -L

$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
```

```bash
$ kubectl get ValidatingWebhookConfiguration
$ kubectl delete ValidatingWebhookConfiguration ingress-nginx-1606642950-admission
$ kubectl delete ValidatingWebhookConfiguration ingress-nginx-1608410324-admission
$ kubectl delete ValidatingWebhookConfiguration ingress-nginx-1608446068-admission
$ kubectl delete ValidatingWebhookConfiguration ingress-nginx-1608454632-admission
$ kubectl delete ValidatingWebhookConfiguration ingress-nginx-1608464957-admission
$ kubectl delete ValidatingWebhookConfiguration ingress-nginx-1608467888-admission



```

```bash
$ kubectl describe rs ingress-nginx-1608467888-controller-755c9c4978 -n geek-apps
$ kubectl get rs ingress-nginx-1608467888-controller-755c9c4978 -n geek-apps -o yaml

$ kubectl describe deploy -n geek-apps ingress-nginx-1608467888-controller
$ kubectl describe svc ingress-nginx-1608467888-controller -n geek-apps
$ kubectl describe svc ingress-nginx-1608467888-controller-admission -n geek-apps

$ kubectl get cm -n geek-apps ingress-controller-leader-nginx -o yaml
$ kubectl get cm -n geek-apps ingress-nginx-1608467888-controller -o yaml
```


```sql
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.3';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.6';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.65';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.68';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.69';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.70';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.71';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.81';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.95';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.96';
REVOKE ALL ON *.* FROM 'replica'@'192.168.1.99';

DROP USER 'replica'@'192.168.1.3';
DROP USER 'replica'@'192.168.1.6';
DROP USER 'replica'@'192.168.1.65';
DROP USER 'replica'@'192.168.1.68';
DROP USER 'replica'@'192.168.1.69';
DROP USER 'replica'@'192.168.1.70';
DROP USER 'replica'@'192.168.1.71';
DROP USER 'replica'@'192.168.1.81';
DROP USER 'replica'@'192.168.1.95';
DROP USER 'replica'@'192.168.1.96';
DROP USER 'replica'@'192.168.1.99';
FLUSH PRIVILEGES;
SELECT Host, User, Password, authentication_string, is_role, default_role FROM mysql.user;

GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.3' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.6' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.65' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.68' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.69' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.70' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.71' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.81' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.95' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.96' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.99' IDENTIFIED BY 'RootPassword' WITH GRANT OPTION;

FLUSH PRIVILEGES;

SELECT Host, User, Password, authentication_string, is_role, default_role FROM mysql.user;
```