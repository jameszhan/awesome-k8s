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
