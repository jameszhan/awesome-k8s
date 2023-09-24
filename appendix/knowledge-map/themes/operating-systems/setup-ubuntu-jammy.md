
#### 基础配置

```bash
# 配置`sudo`免密
$ echo 'james ALL = (ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/james > /dev/null

# 设置时区和本地化
$ sudo timedatectl set-timezone Asia/Shanghai
$ sudo dpkg-reconfigure locales
# sudo localectl set-locale LANG=zh_CN.utf8
$ sudo localectl set-locale LANG=en_US.utf8
```

#### 配置`apt`源

```bash
$ sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak

$ cat <<EOF | sudo tee /etc/apt/sources.list > /dev/null
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy universe
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy universe
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates universe
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates universe

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy-security main restricted
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy-security main restricted
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy-security universe
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy-security universe
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy-security multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy-security multiverse
EOF

$ sudo apt -y update
$ sudo apt -y upgrade
```

#### 生成SSH Key

```bash
$ ssh-keygen -t ed25519 -C "your_email@example.com"
$ eval "$(ssh-agent -s)"
$ ssh-add ~/.ssh/id_ed25519

$ ssh -T git@github.com
```

#### Install Docker

```bash
$ for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

```bash
# Add Docker's official GPG key:
$ sudo apt-get update
$ sudo apt-get install ca-certificates curl gnupg
$ sudo install -m 0755 -d /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$ sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
$ echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt-get update
```

```bash
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
$ sudo systemctl status docker
$ sudo docker run hello-world
```

```bash
$ sudo usermod -aG docker `whoami`
$ sudo usermod -aG docker `id -un`
$ sudo usermod -aG docker $USER
```

#### Install MySQL

```bash
$ sudo apt update
$ sudo apt install mysql-server
```

```bash
$ sudo mysql_secure_installation
$ sudo systemctl enable mysql

$ sudo mysql
```

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'Hello123456_';
FLUSH PRIVILEGES;
```

```bash
$ mysql -u root -pHello123456_
```

#### Anaconda

```bash
$ wget https://repo.anaconda.com/archive/Anaconda3-2023.07-2-Linux-x86_64.sh
$ sha256sum Anaconda3-2023.07-2-Linux-x86_64.sh

$ bash Anaconda3-2023.07-2-Linux-x86_64.sh -p /opt/local/conda

$ conda list
$ conda env list

$ conda update --all
```

