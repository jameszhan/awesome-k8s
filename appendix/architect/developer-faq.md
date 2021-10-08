

#### `TCP/IP`

1. `TCP`协议中是不是所有执行主动关闭的`Socket`都会进入`TIME_WAIT`状态呢？
    > 主动关闭的一方在发送最后一个`ACK`后就会进入`TIME_WAIT`状态，并停留`2MSL(报文最大生存)`时间，这是`TCP/IP`必不可少的，也就是说这一点是"解决"不了的。`TCP/IP`设计者如此设计，主要原因有两个：
   - 防止上一次连接中的包迷路后重新出现，影响新的连接(经过`2MSL`时间后，上一次连接中所有重复的包都会消失)。
   - 为了可靠地关闭`TCP`连接。主动关闭方发送的最后一个`ACK(FIN)`有可能会丢失，如果丢失，被动方会重新发送`FIN`，这时如果主动方处于`CLOSED`状态，就会响应`RST`而不是`ACK`。所以主动方要处于`TIME_WAIT`状态，而不能是`CLOSED`状态。另外，`TIME_WAIT`并不会占用很大的资源，除非受到攻击。

2. 大家来思考一个问题：为什么`TIME_WAIT`状态还需要等`2MSL(报文最大生存时间)`后才能返回到CLOSED状态呢？
    > 答案是虽然双方都同意关闭连接了，而且握手的4个报文也都协调好并发送完毕，按理可以直接回到`CLOSED`状态(就好比从`SYN_SEND`状态到`ESTABLISH`状态一样)，但是因为我们必须要假设网络是不可靠的，你无法保证最后发送的`ACK`报文一定会被对方收到，比如对方正处于`LAST_ACK`状态下的`Socket`可能会因为超时未收到`ACK`报文，这时就需要重发`FIN`报文，所以这个`TIME_WAIT`状态的作用就是用来重发可能丢失了的`ACK`报文的。


#### `Docker`

1. 如何免`sudo`权限运行`docker`命令?
    ```bash
    $ sudo usermod -aG docker james
    ```

#### `GIT`

1.  在使用git拉取github代码时候，clone失败并出现以下错误

    > `fatal: unable to access` '`https://github.com/xxx/xxx.git/`': `LibreSSL SSL_connect: SSL_ERROR_SYSCALL in connection to github.com:443`

    - 出现原因: 之前设置了https的代理
    - 解决方法: 取消https和http代理

  
    ```bash
    $ git config --global --unset http.proxy
    $ git config --global --unset https.proxy
    $ git config --global --list
    ```

1.  `git clone`失败`fatal: early EOF`

    > 这是由于`git`的缓存空间不够，可以尝试将`http.postBuffer`提高(提高到`500Mb`)

    ```bash
    $ git config --global http.postBuffer 524288000
    ```