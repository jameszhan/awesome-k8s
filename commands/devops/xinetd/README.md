

xinetd: extended internet daemon，是新一代的网络守护进程服务程序，又叫超级Internet服务器,常用来管理多种轻量级Internet服务。

##### 系统默认使用xinetd的服务可以分为如下几类。
- ① 标准Internet服务：telnet、ftp。
- ② 信息服务：finger、netstat、systat。
- ③ 邮件服务：imap、imaps、pop2、pop3、pops。
- ④ RPC服务：rquotad、rstatd、rusersd、sprayd、walld。
- ⑤ BSD服务：comsat、exec、login、ntalk、shell、talk。
- ⑥ 内部服务：chargen、daytime、echo、servers、services、time。
- ⑦ 安全服务：irc。
- ⑧ 其他服务：name、tftp、uucp。
具体可以使用xinetd的服务在/etc/services文件中指出