
#### 准备工作

```sql
REVOKE ALL ON *.* FROM 'pma'@'192.168.1.%';
DROP USER 'pma'@'192.168.1.%';

CREATE USER 'pma'@'192.168.1.%' IDENTIFIED BY 'pmapass';
GRANT ALL PRIVILEGES ON `phpmyadmin`.* TO 'pma'@'192.168.1.%' WITH GRANT OPTION;

GRANT SELECT ON *.* TO 'pma'@'192.168.1.%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS `tracks` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'deploy'@'192.168.1.%' IDENTIFIED BY 'pmapass';
GRANT ALL PRIVILEGES ON `tracks`.* TO 'deploy'@'192.168.1.%' WITH GRANT OPTION;


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
$ kubectl create configmap pma-config-inc -n geek-apps --from-file=config.inc.php=templates/config/pma.config.inc.php
$ kubectl get cm pma-config-inc -n geek-apps -o yaml

$ echo -n 'admin' > templates/config/secrets/pma-username.txt
$ echo -n '1f2d1e2e67df' > templates/config/secrets/pma-password.txt

$ kubectl delete secret pma-user-pass -n geek-apps
$ kubectl create secret -n geek-apps generic pma-user-pass \
  --from-file=PMA_CONTROLUSER=templates/config/secrets/pma-username.txt \
  --from-file=PMA_CONTROLPASS=templates/config/secrets/pma-password.txt

$ kubectl get secrets -n geek-apps
$ kubectl describe secrets/pma-user-pass -n geek-apps
$ kubectl get secret pma-user-pass -n geek-apps -o yaml

$ kubectl delete -f templates/pma-deploy.yml
$ kubectl apply -f templates/pma-deploy.yml
$ kubectl describe svc nginx-pma-service -n geek-apps

$ kubectl delete pod check-pma-config -n geek-apps
$ kubectl apply -f templates/check-pma-config.yaml
$ kubectl logs check-pma-config -n geek-apps

$ open https://pma.zizhizhan.com:8443
```
