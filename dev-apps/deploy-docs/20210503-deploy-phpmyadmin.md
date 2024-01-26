
#### 准备工作

```sql
REVOKE ALL ON *.* FROM 'pma'@'192.168.1.%';
DROP USER 'pma'@'192.168.1.%';

CREATE USER 'pma'@'192.168.1.%' IDENTIFIED BY 'pmapass';
GRANT ALL PRIVILEGES ON `phpmyadmin`.* TO 'pma'@'192.168.1.%' WITH GRANT OPTION;

GRANT SELECT ON *.* TO 'pma'@'192.168.1.%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.80' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.1.100' IDENTIFIED BY 'yourrootpass' WITH GRANT OPTION;
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

$ open https://pma.zizhizhan.com
```

#### 更新配置

```bash
$ kubectl edit cm -n geek-apps pma-config
$ kubectl get cm -n geek-apps pma-config -o yaml

# 重启容器
$ kubectl delete pods -n geek-apps --selector="app=phpmyadmin"

# 更新部署镜像到 image: phpmyadmin:5.2.1
$ kubectl edit deployment -n geek-apps synology-phpmyadmin

$ kubectl delete ingress phpmyadmin-ingress -n geek-apps
```