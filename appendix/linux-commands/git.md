```bash
$ git config --global --list
credential.helper=osxkeychain
core.editor=subl
core.filemode=false
user.name=James Zhan
user.email=zhiqiangzhan@gmail.com
user.signingkey=********************
filter.lfs.clean=git-lfs clean -- %f
filter.lfs.smudge=git-lfs smudge -- %f
filter.lfs.process=git-lfs filter-process
filter.lfs.required=true
pull.rebase=false
init.defaultbranch=main

$ touch ~/.gitignore_global
$ git config --global core.excludesfile ~/.gitignore_global
$ git config --get core.excludesfile
/Users/james/.gitignore_global
```

#### FAQ

##### 01. 在使用git拉取github代码时候，clone失败并出现以下错误

> fatal: unable to access '`https://github.com/xxx/xxx.git/`': LibreSSL SSL_connect: SSL_ERROR_SYSCALL in connection to github.com:443 

###### 出现原因
之前设置了https的代理
###### 解决方法
取消https和http代理

```bash
$ git config --global --unset http.proxy
$ git config --global --unset https.proxy
$ git config --global --list
```
##### 02. `git clone`失败`fatal: early EOF`

这是由于git的缓存空间不够，可以尝试将http.postBuffer提高（提高了500Mb）

```bash
$ git config --global http.postBuffer 524288000
```



