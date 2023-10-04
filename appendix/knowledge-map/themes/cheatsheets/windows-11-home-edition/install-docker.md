[Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)

```terminal
"Docker Desktop Installer.exe" install --installation-dir=D:\apps\Docker --wsl-default-data-root=D:\wsl\distros --windows-containers-default-data-root=D:\var\docker
```

[Hyper-V vs WSL 2](https://docs.docker.com/desktop/wsl/)


```powershell
$ docker version
Client:
 Cloud integration: v1.0.35+desktop.5
 Version:           24.0.6
 API version:       1.43
 Go version:        go1.20.7
 Git commit:        ed223bc
 Built:             Mon Sep  4 12:32:48 2023
 OS/Arch:           windows/amd64
 Context:           default

Server: Docker Desktop 4.24.0 (122432)
 Engine:
  Version:          24.0.6
  API version:      1.43 (minimum version 1.12)
  Go version:       go1.20.7
  Git commit:       1a79695
  Built:            Mon Sep  4 12:32:16 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.22
  GitCommit:        8165feabfdfe38c65b599c4993d227328c231fca
 runc:
  Version:          1.1.8
  GitCommit:        v1.1.8-0-g82f18fe
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
  
$ docker compose version
Docker Compose version v2.22.0-desktop.2
```

```bash 
$ docker run hello-world
```