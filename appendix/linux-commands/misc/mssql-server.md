

```bash
$ wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
$ sudo add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2017.list)" 

$ sudo apt -y update
$ sudo apt -y install mssql-server

$ sudo systemctl restart mssql-server
```