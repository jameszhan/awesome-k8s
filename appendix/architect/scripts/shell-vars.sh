#!/bin/bash

func() {
    echo $FUNCNAME
    echo "This script's name is: $0 in func"
    echo "$# parameters in total in func"
    echo "All parameters list as: $@ in func"
    echo "The first parameter is $1 in func"
    echo "The second parameter is $2 in func"
    echo "The third parameter is $3 in func"
    echo "The last return value in $? in func"
}

func 'a' 'b' 'c'

echo "This script's name is: $0"
echo "$# parameters in total"
echo "All parameters list as: $@"
echo "The first parameter is $1"
echo "The second parameter is $2"
echo "The third parameter is $3"
echo "The last return value in $?"


echo "BASH = $BASH"
echo "BASH_VERSION = ${BASH_VERSION}"
echo "BASH_VERSINFO = ${BASH_VERSINFO}"
echo "BASH_ENV = ${BASH_ENV}"
echo "HOSTTYPE = $HOSTTYPE"        # 主机架构: i386/i686/x86_64
echo "MACHTYPE = $MACHTYPE"        # 主机架构-公司-系统

echo "LANG = $LANG"
echo "LC_ALL = $LC_ALL"
echo "LC_CTYPE = $LC_CTYPE"
echo "LC_MESSAGES = $LC_MESSAGES"
echo "LC_NUMERIC = $LC_NUMERIC"

echo "PATH = $PATH"
echo "PWD = $PWD"
echo "OLDPWD = $OLDPWD"
echo "UID = $UID"
echo "EUID = $EUID"
echo "HISTCMD = $HISTCMD"
echo "HOSTNAME = $HOSTNAME"
echo "PS1 = $PS1"                   # 命令提示符
echo "PS2 = $PS2"
echo "PS3 = $PS3"
echo "PS4 = $PS4"
echo "RANDOM = $RANDOM"
echo "REPLY = $REPLY"
echo "SECONDS = $SECONDS"
echo "SHELLOPTS = $SHELLOPTS"
echo "SHLVL = $SHLVL"
echo "TMOUT = $TMOUT"

echo "PIPESTATUS = $PIPESTATUS"     # 最近运行过的前台管道进程的退出状态值的列表
echo "PPID = $PPID"                 # 父进程ID
echo "LINENO = $LINENO"
echo "LINES = $LINES"
echo "COLUMNS = $COLUMNS"
echo "COMP_LINE = $COMP_LINE"
echo "COMP_POINT = $COMP_POINT"
echo "COMP_WORDS = $COMP_WORDS"
echo "DIRSTACK = $DIRSTACK"
echo "FIGNORE = $FIGNORE"
echo "GLOBIGNORE = $GLOBIGNORE"
echo "GROUPS = $GROUPS"
echo "HISTCONTROL = $HISTCONTROL"
echo "IGNOREEOF = $IGNOREEOF"
echo "INPUTRC = $INPUTRC"
echo "MAILCHECK = $MAILCHECK"
echo "OPTERR = $OPTERR"





