## Linux运维最佳实践

### 高性能网站构建
#### 深入理解DNS原理与部署BIND
001. 禁用权威域名服务器递归查询
002. 构建域名解析缓存
003. 配置`chroot`加固BIND
004. 利用BIND实现简单负载均衡
005. 详解BIND视图技术及优化
006. 关注BIND的漏洞信息
007. 掌握BIND监控技巧
#### 全面解析CDN技术与实战
008. 架构典型CDN系统
009. 理解HTTP协议中的缓存控制：服务器端缓存控制头部信息
010. 配置和优化Squid
011. 优化缓存防盗链
012. 实践视频点播CDN
013. 设计大规模下载调度系统
#### 负载均衡和高可用技术
014. 负载均衡和高可用技术
015. 4层负载均衡
016. 7层负载均衡
017. 基于DNS的负载均衡
018. 基于重定向的负载均衡
019. 基于客户端的负载均衡
020.  高可用技术推荐
#### 配置及调优LVS
021. 模式选择
    > LVS集群中，支持以下3种转发模式：LVS-NAT、LVS-DR、LVS-Tun。
022. LVS+Keepalived实战精讲
023. 多组LVS设定注意事项
024. 注意网卡参数与MTU问题
025. LVS监控要点
026. LVS排错步骤推荐
#### 使用HAProxy实现4层和7层代理
027. 安装与优化
028. HAProxy+Keepalived实战
029. HAProxy监控
030. HAProxy排错步骤推荐
#### 实践Nginx的反向代理和负载均衡
031. 安装与优化
032. Nginx监控
033. Nginx排错步骤推荐
034. Nginx常见问题的处理方法
#### 部署商业负载均衡设备NetScaler
035. NetScaler的初始化设置
036. NetScaler基本负载均衡核心参数配置
037. NetScaler内容交换核心参数配置
038. NetScaler的Weblog配置与解析
039. NetScaler高级运维指南
040. NetScaler监控
041. NetScaler排错步骤推荐
042. NetScaler Surge Protection引起的问题案例
043. LVS、HAProxy、Nginx、NetScaler的大对比
044. 中小型网站负载均衡方案推荐
     1. 在日访问量在3000万PV以下时，使用简单的DNS轮询配合监控，基本上可以满足业务需求了。
     2. 在日访问量达到3000万PV时，使用Nginx作为反向代理。如果对高可用要求不高，可以使用单台Nginx，另外加强监控，出现故障时，由系统运维工程师进行干预恢复业务。一般采用Nginx→Web服务器集群的架构。
     3. 在日访问量在3000万PV~1亿PV时，可以使用HAProxy+Keepalived→Nginx→Web服务器集群的架构。HAProxy负责TCP负载均衡，Nginx负责7层调度，Nginx可以配置多台进行负载分担。
     4. 在日访问量达到1亿PV以上时，采用LVS-DR+Keepalived→Nginx→Web服务器集群的架构。LVS-DR负责TCP负载均衡，Nginx负责7层调度，Nginx可以配置多台进行负载分担。在此架构中，DR模式的LVS配置可以最大限度地提升吞吐量。在预算可以接受范围内，考虑把LVS-DR模式替换为NetScaler
#### 配置高性能网站
045. 深入理解HTTP协议
046. 配置高性能静态网站
047. 配置高性能动态网站
048. 配置多维度网站监控
#### 优化MySQL数据库
049. MySQL配置项优化
050. 使用主从复制扩展读写能力
051. 使用MHA构建高可用MySQL
### 服务器安全和监控
#### 构建企业级虚拟专用网络
052. 常见的VPN构建技术
     1. PPTP（Point-to-Point Tunneling Protocol，点到点的隧道协议）VPN。
     2. IPSec（Internet Protocol Security，互联网协议安全）VPN。
     3. SSL/TLS（Secure Sockets Layer，安全接口层）VPN。
053. 深入理解OpenVPN的特性
054. 使用OpenVPN创建Peer-to-Peer的VPN
055. 使用OpenVPN创建Remote Access的VPN
056. 使用OpenVPN创建Site-to-Site的VPN 
057. 回收客户端的证书
058. 使用OpenVPN提供的各种script功能
059. OpenVPN的排错步骤
#### 实施Linux系统安全策略与入侵检测
060. 物理层安全措施
061. 网络层安全措施
062. 应用层安全措施
063. 入侵检测系统配置
064. Linux备份与安全
#### 实践Zabbix自定义模板技术
065. 4步完成Zabbix Server搭建
066. Zabbix利器Zatree
067. Zabbix Agent自动注册
068. 基于自动发现的KVM虚拟机性能监控
#### 服务器硬件监控
069. 服务器硬盘监控
070. SSD定制监控
071. 服务器带外监控：带外邮件警告
### 网络分析技术
#### 使用tcpdump与Wireshark解决疑难问题
072. 理解tcpdump的工作原理
073. 学习tcpdump的5个参数和过滤器
074. 在Android系统上抓包的最佳方法
075. 使用RawCap抓取回环端口的数据
076. 熟悉Wireshark的最佳配置项
077. 使用Wireshark分析问题的案例
078. 使用libpcap进行自动化分析
#### 分析与解决运营商劫持问题
079. 深度分析运营商劫持的技术手段
080. 在关键文件系统部署HTTPS的实战
#### 深度实践iptables
081. 禁用连接追踪
082. 慎重禁用ICMP协议
083. 网络地址转换在实践中的案例
084. 深入理解iptables各种表和各种链
### 运维自动化和游戏运维
#### 使用Kickstart完成批量系统安装
085. Kickstart精要
086. 系统配置参数优化
#### 利用Perl编程实施高效运维
087. 多进程编程技巧
088. 调整Socket编程的超时时间
089. 批量管理带外配置
090. 推广邮件的推送优化
091. 使用PerlTidy美化代码
#### 精通Ansible实现运维自动化
092. 理解Ansible
093. 学习Ansible Playbook使用要点
094. Ansible模块介绍及开发
095. 理解Ansible插件
096. Ansible自动化运维实例：Ansible自动安装配置zabbix客户端
#### 掌握端游运维的技术要点
097. 了解大型端游的技术架构
098. 理解游戏运维体系发展历程
099. 自动化管理技术
100. 自动化监控技术
101. 运维安全体系
102. 运维服务管理体系
103. 运维体系框架建设
#### 精通手游运维的架构体系
104. 推荐的手游架构
105. 手游容量规划       