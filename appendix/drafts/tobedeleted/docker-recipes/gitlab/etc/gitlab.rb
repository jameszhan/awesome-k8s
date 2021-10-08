
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.ym.163.com"
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "zhiqiangzhan@163.com"
gitlab_rails['smtp_password'] = "YOUR-PASSWORD"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
gitlab_rails['gitlab_email_from'] = 'zhiqiangzhanx@163.com'
gitlab_rails['smtp_domain'] = "smtp.ym.163.com"


# Disable the built-in Postgres
postgresql['enable'] = false
postgresql['ssl'] = 'off'

# Fill in the connection details for database.yml
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_encoding'] = 'utf8'
gitlab_rails['db_host'] = '192.168.1.160'
gitlab_rails['db_port'] = 5432
gitlab_rails['db_username'] = 'git'
gitlab_rails['db_password'] = 'YOUR-PASSWORD'
gitlab_rails['db_database'] = "gitlab"


redis['enable'] = false
gitlab_rails['redis_host'] = "192.168.1.6"
gitlab_rails['redis_port'] = 6379
gitlab_rails['redis_ssl'] = false
# gitlab_rails['redis_password'] = nil
gitlab_rails['redis_database'] = 0
gitlab_rails['redis_enable_client'] = true

gitlab_rails['initial_root_password'] = '<my_strong_password>'

### GitLab Shell settings for GitLab
# gitlab_rails['gitlab_shell_ssh_port'] = 22
# gitlab_rails['gitlab_shell_git_timeout'] = 800