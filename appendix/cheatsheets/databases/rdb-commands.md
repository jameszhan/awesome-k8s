### TL;DR

#### MySQL

```bash
# Connect to a database:
mysql database_name

# Connect to a database, user will be prompted for a password:
mysql -u user --password database_name

# Connect to a database on another host:
mysql -h database_host database_name

# Connect to a database through a Unix socket:
mysql --socket path/to/socket.sock

# Execute SQL statements in a script file (batch file):
mysql -e "source filename.sql" database_name

# Restore a database from a backup created with `mysqldump` (user will be prompted for a password):
mysql --user user --password database_name < path/to/backup.sql

# Restore all databases from a backup (user will be prompted for a password):
mysql --user user --password < path/to/backup.sql
```

```bash
# Create a backup (user will be prompted for a password):
mysqldump --user user --password database_name --result-file=path/to/file.sql

# Backup a specific table redirecting the output to a file (user will be prompted for a password):
mysqldump --user user --password database_name table_name > path/to/file.sql

# Backup all databases redirecting the output to a file (user will be prompted for a password):
mysqldump --user user --password --all-databases > path/to/file.sql

# Backup all databases from a remote host, redirecting the output to a file (user will be prompted for a password):
mysqldump --host=ip_or_hostname --user user --password --all-databases > path/to/file.sql
```

#### PostgreSQL

```bash
# Connect to the database. By default, it connects to the local socket using port 5432 with the currently logged in user:
psql database

# Connect to the database on given server host running on given port with given username, without a password prompt:
psql -h host -p port -U username database

# Connect to the database; user will be prompted for password:
psql -h host -p port -U username -W database

# Execute a single SQL query or PostgreSQL command on the given database (useful in shell scripts):
psql -c 'query' database

# Execute commands from a file on the given database:
psql database -f file.sql
```

#### SQLite

```bash
# Start an interactive shell with a new database:
sqlite3

# Open an interactive shell against an existing database:
sqlite3 path/to/database.sqlite3

# Execute an SQL statement against a database and then exit:
sqlite3 path/to/database.sqlite3 'SELECT * FROM some_table;'
```

### 命令对比

| 功能/操作       | SQLite3                      | MySQL                                                                | PostgreSQL                                          |
|-------------|------------------------------|----------------------------------------------------------------------|-----------------------------------------------------|
| 连接数据库       | `sqlite3 database_name.db`   | `mysql -u username -p database_name`                                 | `psql -U username -d database_name`                 |
| 列出所有数据库     | `.databases`                 | `SHOW DATABASES;`                                                    | `\l` 或 `\list`                                      |
| 切换数据库       | 不支持（重新连接数据库文件）               | `USE database_name;`                                                 | `\c database_name`                                  |
| 列出当前数据库所有表  | `.tables`                    | `SHOW TABLES;`                                                       | `\dt`                                               |
| 查看表结构       | `.schema table_name`         | `DESCRIBE table_name;`                                               | `\d table_name`                                     |
| 执行多个SQL命令   | `.read filename.sql`         | 通过在命令行中输入SQL文件                                                       | `\i filename.sql`                                   |
| 导出数据库为SQL文件 | `.dump > output.sql`         | `mysqldump -u username -p database_name > output.sql`                | `pg_dump database_name > output.sql`                |
| 导入SQL文件     | `.read input.sql`            | `mysql -u username -p database_name < input.sql`                     | `psql -U username -d database_name < input.sql`     |
| 创建用户        | 不支持（没有用户系统）                  | `CREATE USER 'username'@'hostname';`                                 | `CREATE USER username;`                             |
| 更改密码        | 不支持（没有用户系统）                  | `SET PASSWORD FOR 'username'@'hostname' = PASSWORD('new_password');` | `ALTER USER username WITH PASSWORD 'new_password';` |
| 查看当前活动连接    | `PRAGMA database_list;`      | `SHOW PROCESSLIST;`                                                  | `SELECT * FROM pg_stat_activity;`                   |
| 启用外键约束      | `PRAGMA foreign_keys = ON;`  | `SET foreign_key_checks = 1;`                                        | `SET CONSTRAINTS ALL DEFERRED;`                     |
| 禁用外键约束      | `PRAGMA foreign_keys = OFF;` | `SET foreign_key_checks = 0;`                                        | `SET CONSTRAINTS ALL IMMEDIATE;`                    |
| 查看执行计划      | `EXPLAIN QUERY PLAN SQL语句;`  | `EXPLAIN SQL语句;`                                                     | `EXPLAIN SQL语句;`                                    |













