

##### `Python`常用库

- Django：Python中最流行的Web框架。
- Tornado：一个Web框架和异步网络库。
- Flask：一个是轻量级的、易于采用、文档化的开发RESTful API的Web框架。
- CherryPy：一个极简的Python Web框架，服从HTTP/1.1协议且具有WSGI线程池。
- requests：requests是用Python语言编写的，基于urllib，但设计得非常优雅，非常符合人的使用习惯。它采用的是Apache2 Licensed开源协议的HTTP库，比urllib更加方便，可以节约大量的工作- 时间，完全满足HTTP测试需求。
- yagmail：在Python中使用smtplib标准库是一件非常麻烦的事情，而yagmail第三方类库封装了smtplib，使得我们发邮件更人性化和方便（通常两三行代码就能发送邮件）。
- psutil：[psutil](http://code.google.com/p/psutil/)是一个跨平台库，能够轻松获取系统运行的进程和系统利用率（包括CPU、内存、磁盘、网络等）信息。它主要应用于系统监控，负责分析和- 限制系统资源及进程的管理。它实现了相应命令行工具提供的功能，如ps、top、lsof、netstat、ifconfig、who、df、kill、free、nice、ionice、iostat、iotop、uptime、pidof、tty、- taskset、pmap等。目前支持32位和64位的`Linux`、`Windows`、`OS X`、`FreeBSD`和`Sun Solaris`等操作系统。
- sh：sh类库可以让我们用Python函数的语法去调用`Linux Shell`命令，相比较`Subprocess`标准库，sh确实方便多了。
- Boto3：我们可以基于[Boto3](https://aws.amazon.com/cn/sdk-for-python/)快速使用AWS。Boto3可以支持我们轻松地将Python应用程序、库或脚本与AWS服务进行集成，包括Amazon S3、Amazon EC2和Amazon DynamoDB等。
- Fabric：轻量级的自动配置管理库，代码和API都较简便，用较少的代码就可以实现集群机器的批量管理。
- Paramiko：Fabric工具的基础库，基于Python实现SSH2的远程安全连接，支持密码及私钥安全认证，可以实现远程执行命令、文件传输、中间SSH代理等功能。
- Srapy：Python中鼎鼎有名的爬虫框架，非常建议学习和掌握。
- Beautiful Soup：解析HTML的利器，现在最新版本为BS4。`Beautiful Soup`是用来解析HTML的利器，特点就是好用，但速度比Xpath慢。Scrapy除了支持Xpath以外，也是支持`Beautiful Soup`的。
- Selenium：它是一套完整的Web应用程序测试系统，工作中主要用来模拟浏览器做自动化测试工作。
- Jinja2：Jinja2是基于Python的模板引擎，功能类似于PHP的Smarty。
- Mustache：老牌的Python模板引擎，在Mesos/Marathon分布式系统中经常用。
- rq：简单的轻量级的Python任务队列。
- celery：一个分布式异步任务队列/作业队列，基于分布式消息传递。
- supervisor：进程管理工具，在Linux/UNIX下管理进程很方便，但不支持Windows系统。