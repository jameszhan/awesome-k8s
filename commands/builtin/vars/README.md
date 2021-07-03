

```bash
$ echo "PWD = $PWD"
$ echo "OLDPWD = $OLDPWD"

echo "PS1 = $PS1"                   
echo "PS2 = $PS2"                   
echo "PS3 = $PS3"                   
echo "PS4 = $PS4"    
```




```bash
$ bash shell-envs.md
```

#### 命令提示符

```bash
$ echo "PS1 = $PS1"
```

- `\W`: 当前工作目录的`basename`
- `\w`: 当前工作目录的全路径
- `\d`: 日期，默认格式为'周月日'
- `\H`: 完整的主机名
- `\h`: 主机名
- `\t`: 24小时制的时间，格式为`HH:MM:SS`
- `\T`: 12小时制的时间
- `\u`: 当前用户的用户名
- `\$`: 如果UID是0则显示`#`否则显示`$`