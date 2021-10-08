#### 配置`sudo`免密

```bash
$ apt -y install sudo
$ usermod -a -G sudo james
$ echo 'james ALL = (ALL) NOPASSWD: ALL' > /etc/sudoers.d/james
```

#### 时区和`locale`配置

```bash
# 设置当前时区
$ timedatectl
$ sudo timedatectl set-timezone Asia/Shanghai

# 设置本地化参数。
$ sudo dpkg-reconfigure locales
$ localectl
# $ sudo localectl set-locale LANG=zh_CN.utf8
$ sudo localectl set-locale LANG=en_US.UTF-8
$ sudo localectl set-keymap en_US
```

### [Network setup](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html)

#### List of network address ranges

| Class | network addresses           | net mask      | net mask /bits | of subnets |
| ----- | --------------------------- | ------------- | -------------- | ---------- |
| A     | 10.x.x.x                    | 255.0.0.0     | /8             | 1          |
| B     | 172.16.x.x — 172.31.x.x     | 255.255.0.0   | /16            | 16         |
| C     | 192.168.0.x — 192.168.255.x | 255.255.255.0 | /24            | 256        |

#### List of network configuration tools

| packages              | description                                                                     |
| --------------------- | ------------------------------------------------------------------------------- |
| network-manager       | NetworkManager (daemon): manage the network automatically                       |
| network-manager-gnome | NetworkManager (GNOME frontend)                                                 |
| ifupdown              | standardized tool to bring up and down the network (Debian specific)            |
| isc-dhcp-client       | DHCP client                                                                     |
| pppoeconf             | configuration helper for PPPoE connection                                       |
| wpasupplicant         | client support for WPA and WPA2 (IEEE 802.11i)                                  |
| wpagui                | Qt GUI client for wpa_supplicant                                                |
| wireless-tools        | tools for manipulating Linux Wireless Extensions                                |
| iw                    | tool for configuring Linux wireless devices                                     |
| iproute2              | iproute2, IPv6 and other advanced network configuration: ip(8), tc(8), etc      |
| iptables              | administration tools for packet filtering and NAT (Netfilter)                   |
| iputils-ping          | test network reachability of a remote host by hostname or IP address (iproute2) |
| iputils-arping        | test network reachability of a remote host specified by the ARP address         |
| iputils-tracepath     | trace the network path to a remote host                                         |
| ethtool               | display or change Ethernet device settings                                      |
| mtr-tiny              | trace the network path to a remote host (curses)                                |
| mtr                   | trace the network path to a remote host (curses and GTK)                        |
| gnome-nettool         | tools for common network information operations (GNOME)                         |
| nmap                  | network mapper / port scanner (Nmap, console)                                   |
| zenmap                | network mapper / port scanner (GTK)                                             |
| tcpdump               | network traffic analyzer (Tcpdump, console)                                     |
| wireshark             | network traffic analyzer (Wireshark, GTK)                                       |
| tshark                | network traffic analyzer (console)                                              |
| tcptrace              | produce a summarization of the connections from tcpdump output                  |
| snort                 | flexible network intrusion detection system (Snort)                             |
| ntopng                | display network usage in web browser                                            |
| dnsutils              | network clients provided with BIND: nslookup(8), nsupdate(8), dig(8)            |
| dlint                 | check DNS zone information using nameserver lookups                             |
| dnstracer             | trace a chain of DNS servers to the source                                      |

#### Translation table from obsolete net-tools commands to new iproute2 commands

| obsolete net-tools | new iproute2 etc. | manipulation                                   |
| ------------------ | ----------------- | ---------------------------------------------- |
| ifconfig(8)        | ip addr           | protocol (IP or IPv6) address on a device      |
| route(8)           | ip route          | routing table entry                            |
| arp(8)             | ip neigh          | ARP or NDISC cache entry                       |
| ipmaddr            | ip maddr          | multicast address                              |
| iptunnel           | ip tunnel         | tunnel over IP                                 |
| nameif(8)          | ifrename(8)       | name network interfaces based on MAC addresses |
| mii-tool(8)        | ethtool(8)        | Ethernet device settings                       |

#### List of low level network commands

| command                                | description                                               |
| -------------------------------------- | --------------------------------------------------------- |
| ip addr show                           | display the link and address status of active interfaces  |
| route -n                               | display all the routing table in numerical addresses      |
| ip route show                          | display all the routing table in numerical addresses      |
| arp                                    | display the current content of the ARP cache tables       |
| ip neigh                               | display the current content of the ARP cache tables       |
| plog                                   | display ppp daemon log                                    |
| ping yahoo.com                         | check the Internet connection to "yahoo.com"              |
| whois yahoo.com                        | check who registered "yahoo.com" in the domains database  |
| traceroute yahoo.com                   | trace the Internet connection to "yahoo.com"              |
| tracepath yahoo.com                    | trace the Internet connection to "yahoo.com"              |
| mtr yahoo.com                          | trace the Internet connection to "yahoo.com" (repeatedly) |
| dig [@dns-server.com] example.com `[{a|mx|any}]` | check DNS records of "example.com" by "dns-server.com" for a "a", "mx", or "any" record |
| iptables -L -n                         | check packet filter                                       |
| netstat -a                             | find all open ports                                       |
| netstat -l --inet                      | find listening ports                                      |
| netstat -ln --tcp                      | find listening TCP ports (numeric)                        |
| dlint example.com                      | check DNS zone information of "example.com"               |

#### List of network optimization tools

| packages  | description                                                 |
| --------- | ----------------------------------------------------------- |
| iftop     | display bandwidth usage information on an network interface |
| iperf     | Internet Protocol bandwidth measuring tool                  |
| ifstat    | InterFace STATistics Monitoring                             |
| bmon      | portable bandwidth monitor and rate estimator               |
| ethstatus | script that quickly measures network device throughput      |
| bing      | empirical stochastic bandwidth tester                       |
| bwm-ng    | small and simple console-based bandwidth monitor            |
| ethstats  | console-based Ethernet statistics monitor                   |
| ipfm      | bandwidth analysis tool                                     |

#### Netfilter infrastructure

| packages        | description                                                                      |
| --------------- | -------------------------------------------------------------------------------- |
| iptables        | administration tools for netfilter (iptables(8) for IPv4, ip6tables(8) for IPv6) |
| arptables       | administration tools for netfilter (arptables(8) for ARP)                        |
| ebtables        | administration tools for netfilter (ebtables(8) for Ethernet bridging)           |
| iptstate        | continuously monitor netfilter state (similar to top(1))                         |
| shorewall-init  | Shoreline Firewall initialization                                                |
| shorewall       | Shoreline Firewall, netfilter configuration file generator                       |
| shorewall-lite  | Shoreline Firewall, netfilter configuration file generator (light version)       |
| shorewall6      | Shoreline Firewall, netfilter configuration file generator (IPv6 version)        |
| shorewall6-lite | Shoreline Firewall, netfilter configuration file generator (IPv6, light version) |
