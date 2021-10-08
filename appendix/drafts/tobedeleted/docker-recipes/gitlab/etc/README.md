
```bash
# Create the file repository configuration:
$ sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
$ sudo apt -y update

# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
$ sudo apt -y install postgresql

$ systemctl status postgresql
```

#### 配置新用户和新数据库

```bash
$ sudo -i -u postgres
$ createdb gitlab 'Gitlab'
$ createuser -c 128 -d -r -s git
$ psql -c "ALTER USER git PASSWORD 'your@passwd';"
$ psql -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO git";
$ psql -c "GRANT ALL ON DATABASE gitlab TO git;"

$ vim /etc/postgresql/13/main/postgresql.conf
$ vim /etc/postgresql/13/main/pg_hba.conf
```

```conf
listen_addresses = '0.0.0.0'
```

```conf
host    gitlab  git 192.168.1.0/24  md5
```


> 重启服务

```bash
$ sudo systemctl restart postgresql
```


```bash
$ sudo docker exec -it gitlab bash
```

```bash
$ psql --host=192.168.1.160 --port=5432 --username=git --dbname=gitlab -c 'show client_encoding;'
```