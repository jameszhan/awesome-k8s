
```bash
# 安装docker
$ ansible-playbook -i hosts docker.yml -u deploy -v
```


#### 时间同步检查

```bash
$ ansible -i hosts all -m shell -a 'chronyc sources -v' -u deploy --become -v
$ ansible -i hosts all -m shell -a 'chronyc sourcestats' -u deploy --become -v
```