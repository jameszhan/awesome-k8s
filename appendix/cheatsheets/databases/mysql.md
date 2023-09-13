
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

#### 临时取消外键约束

```bash
SET foreign_key_checks = 0;
TRUNCATE TABLE category;
SET foreign_key_checks = 1;
```
