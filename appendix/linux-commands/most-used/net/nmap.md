#### Nmap支持的4种最基本的扫描方式：
- TCP connect()端口扫描 (-sT参数、-sP用于扫描整个局域网段)，进行完整的握手过程(SYN、SYN-ACK和ACK)，一次完整执行的握手过程表明远程主机端口是打开的。。
- TCP同步(SYN)端口扫描 (-sS参数)，TCP SYN扫描创建的是半打开的连接，TCP SYN扫描发送的是复位标记（RST）而不是结束ACK标记（即SYN、SYN-ACK或RST）。
  - 如果远程主机正在监听且端口是打开的，则远程主机用SYN-ACK应答，Nmap发送一个RST
  - 如果远程主机的端口是关闭的，则它的应答将是RST，此时Nmap转入下一个端口
- UDP端口扫描 (-sU参数)。
- TCP ACK扫描 (-sA参数)。