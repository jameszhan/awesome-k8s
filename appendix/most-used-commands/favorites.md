#### 常用命令

##### 安装多语言支持

```bash
$ sudo dpkg-reconfigure locales
```

##### 检查重复文件

```bash
$ ls | xargs shasum | sort
```

##### 批量重命名

```bash
$ rename 's/(\d+).jpg/prefix-$1.jpg/' *.jpg
```

##### `libvirt`虚拟机镜像管理

```bash
$ qemu-img check proxyserver.img
$ qemu-img info proxyserver.img

$ guestmount -i -a /app/var/vms/images/proxyserver.img -r /app/var/images
$ sudo umount /app/var/images
```

##### `base64`

```bash
$ echo -n "superuser" | base64
$ echo -n "Hello123456" | base64
$ echo "SGVsbG8xMjM0NTY=" | base64 --decode
```

#### `openssl`

```bash
$ openssl help
```
##### Standard commands
```
asn1parse         ca                ciphers           cms
crl               crl2pkcs7         dgst              dhparam
dsa               dsaparam          ec                ecparam
enc               engine            errstr            gendsa
genpkey           genrsa            help              list
nseq              ocsp              passwd            pkcs12
pkcs7             pkcs8             pkey              pkeyparam
pkeyutl           prime             rand              rehash
req               rsa               rsautl            s_client
s_server          s_time            sess_id           smime
speed             spkac             srp               storeutl
ts                verify            version           x509
```

##### Message Digest commands (see the `dgst' command for more details)
```
blake2b512        blake2s256        gost              md4
md5               mdc2              rmd160            sha1
sha224            sha256            sha3-224          sha3-256
sha3-384          sha3-512          sha384            sha512
sha512-224        sha512-256        shake128          shake256
sm3
```

##### Cipher commands (see the `enc' command for more details)
```
aes-128-cbc       aes-128-ecb       aes-192-cbc       aes-192-ecb
aes-256-cbc       aes-256-ecb       aria-128-cbc      aria-128-cfb
aria-128-cfb1     aria-128-cfb8     aria-128-ctr      aria-128-ecb
aria-128-ofb      aria-192-cbc      aria-192-cfb      aria-192-cfb1
aria-192-cfb8     aria-192-ctr      aria-192-ecb      aria-192-ofb
aria-256-cbc      aria-256-cfb      aria-256-cfb1     aria-256-cfb8
aria-256-ctr      aria-256-ecb      aria-256-ofb      base64
bf                bf-cbc            bf-cfb            bf-ecb
bf-ofb            camellia-128-cbc  camellia-128-ecb  camellia-192-cbc
camellia-192-ecb  camellia-256-cbc  camellia-256-ecb  cast
cast-cbc          cast5-cbc         cast5-cfb         cast5-ecb
cast5-ofb         des               des-cbc           des-cfb
des-ecb           des-ede           des-ede-cbc       des-ede-cfb
des-ede-ofb       des-ede3          des-ede3-cbc      des-ede3-cfb
des-ede3-ofb      des-ofb           des3              desx
idea              idea-cbc          idea-cfb          idea-ecb
idea-ofb          rc2               rc2-40-cbc        rc2-64-cbc
rc2-cbc           rc2-cfb           rc2-ecb           rc2-ofb
rc4               rc4-40            seed              seed-cbc
seed-cfb          seed-ecb          seed-ofb          sm4-cbc
sm4-cfb           sm4-ctr           sm4-ecb           sm4-ofb
```

```bash
$ echo -n 'Hello World' | openssl enc -base64
$ echo -n 'Hello World' | base64

$ echo -n 'Hello World' | openssl base64 | openssl base64 -d
$ echo -n 'Hello World' | base64 | base64 -d

$ echo -n 'Hello World' | openssl md5
$ echo -n 'Hello World' | md5sum

$ echo -n 'Hello World' | openssl sha1
$ echo -n 'Hello World' | shasum

$ echo -n 'Hello World' | openssl sha256
$ echo -n 'Hello World' | sha256sum

$ echo -n 'Hello World' | openssl sha512
$ echo -n 'Hello World' | sha512sum
```

#### 进程相关

- `pstree`

#### 文件系统相关

##### `sshfs`

```bash
$ sshfs james@ubuntu-5700u.local:/opt/etc /opt/var/tmp
$ umount /opt/var/tmp
```

##### `nfs`

```bash
$ sudo mount -v -t nfs -o rw,vers=4.1 synology-ds918.local:/volume1/omnifocus /opt/var/synology
$ sudo unmount /opt/var/synology
```

##### `9p`

```bash
$ sudo mount -v -t 9p -o trans=virtio,ro html /usr/share/nginx/html
```

##### `bind`

```bash
$ sudo mount -v -o bind,ro /volume1/photo/album/dedao /volume1/shared/k8s/gallery/dedao
$ sudo mount -v --bind -o ro /volume1/photo/album/dedao /volume1/shared/k8s/gallery/dedao

# 直接配置只读不生效，需要以下两步
$ sudo mount -v --bind /volume1/photo/album/dedao /volume1/shared/k8s/gallery/dedao
$ sudo mount -v -o bind,remount,ro /volume1/shared/k8s/gallery/dedao
```

##### `SquashFS`

###### On macOS

```bash
$ brew install squashfs
$ mksquashfs share osx-fragments.1m.squash -b 1m -no-xattrs -root-owned
```
###### On Linux

```bash
$ sudo mount -t squashfs -o loop osx-fragments.1m.squash /home/james/mountpoints
$ sudo umount /home/james/mountpoints
```


#### `route`

`route -n`

##### `ubuntu-5700u`

| Destination   | Gateway     | Genmask         | Flags | Metric | Ref | Use | Iface  |
| ------------- | ----------- | --------------- | ----- | ------ | --- | --- | ------ |
| 0.0.0.0       | 192.168.1.1 | 0.0.0.0         | UG    | 0      | 0   | 0   | br0    |
| 0.0.0.0       | 192.168.1.1 | 0.0.0.0         | UG    | 600    | 0   | 0   | wlp3s0 |
| 192.168.1.0   | 0.0.0.0     | 255.255.255.0   | U     | 0      | 0   | 0   | br0    |
| 192.168.1.0   | 0.0.0.0     | 255.255.255.0   | U     | 0      | 0   | 0   | wlp3s0 |
| 192.168.1.1   | 0.0.0.0     | 255.255.255.255 | UH    | 600    | 0   | 0   | wlp3s0 |
| 192.168.122.0 | 0.0.0.0     | 255.255.255.0   | U     | 0      | 0   | 0   | virbr0 |

##### `k8s-node001`

| Destination | Gateway     | Genmask         | Flags | Metric | Ref | Use | Iface     |
| ----------- | ----------- | --------------- | ----- | ------ | --- | --- | --------- |
| 0.0.0.0     | 192.168.1.1 | 0.0.0.0         | UG    | 100    | 0   | 0   | enp1s0    |
| 10.244.0.0  | 0.0.0.0     | 255.255.255.0   | U     | 0      | 0   | 0   | cni0      |
| 10.244.2.0  | 10.244.2.0  | 255.255.255.0   | UG    | 0      | 0   | 0   | flannel.1 |
| 10.244.4.0  | 10.244.4.0  | 255.255.255.0   | UG    | 0      | 0   | 0   | flannel.1 |
| 172.17.0.0  | 0.0.0.0     | 255.255.0.0     | U     | 0      | 0   | 0   | docker0   |
| 192.168.1.0 | 0.0.0.0     | 255.255.255.0   | U     | 0      | 0   | 0   | enp1s0    |
| 192.168.1.1 | 0.0.0.0     | 255.255.255.255 | UH    | 100    | 0   | 0   | enp1s0    |

#### `k8s-node002`

| Destination | Gateway     | Genmask         | Flags | Metric | Ref | Use | Iface     |
| ----------- | ----------- | --------------- | ----- | ------ | --- | --- | --------- |
| 0.0.0.0     | 192.168.1.1 | 0.0.0.0         | UG    | 100    | 0   | 0   | enp1s0    |
| 10.244.0.0  | 10.244.0.0  | 255.255.255.0   | UG    | 0      | 0   | 0   | flannel.1 |
| 10.244.2.0  | 0.0.0.0     | 255.255.255.0   | U     | 0      | 0   | 0   | cni0      |
| 10.244.4.0  | 10.244.4.0  | 255.255.255.0   | UG    | 0      | 0   | 0   | flannel.1 |
| 172.17.0.0  | 0.0.0.0     | 255.255.0.0     | U     | 0      | 0   | 0   | docker0   |
| 192.168.1.0 | 0.0.0.0     | 255.255.255.0   | U     | 0      | 0   | 0   | enp1s0    |
| 192.168.1.1 | 0.0.0.0     | 255.255.255.255 | UH    | 100    | 0   | 0   | enp1s0    |

#### `k8s-node003`

| Destination | Gateway     | Genmask         | Flags | Metric | Ref | Use | Iface     |
| ----------- | ----------- | --------------- | ----- | ------ | --- | --- | --------- |
| 0.0.0.0     | 192.168.1.1 | 0.0.0.0         | UG    | 100    | 0   | 0   | enp1s0    |
| 10.244.0.0  | 10.244.0.0  | 255.255.255.0   | UG    | 0      | 0   | 0   | flannel.1 |
| 10.244.2.0  | 10.244.2.0  | 255.255.255.0   | UG    | 0      | 0   | 0   | flannel.1 |
| 10.244.4.0  | 0.0.0.0     | 255.255.255.0   | U     | 0      | 0   | 0   | cni0      |
| 172.17.0.0  | 0.0.0.0     | 255.255.0.0     | U     | 0      | 0   | 0   | docker0   |
| 192.168.1.0 | 0.0.0.0     | 255.255.255.0   | U     | 0      | 0   | 0   | enp1s0    |
| 192.168.1.1 | 0.0.0.0     | 255.255.255.255 | UH    | 100    | 0   | 0   | enp1s0    |

#### `k8s-node006`

| Destination   | Gateway       | Genmask         | Flags | Metric | Ref | Use | Iface           |
| ------------- | ------------- | --------------- | ----- | ------ | --- | --- | --------------- |
| 0.0.0.0       | 192.168.1.1   | 0.0.0.0         | UG    | 100    | 0   | 0   | enp1s0          |
| 10.244.19.64  | 192.168.1.118 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.38.128 | 0.0.0.0       | 255.255.255.192 | U     | 0      | 0   | 0   | *               |
| 10.244.38.129 | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | califd3e36942f2 |
| 10.244.38.130 | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | cali06c83247aeb |
| 10.244.77.0   | 192.168.1.101 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.88.64  | 192.168.1.117 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.88.192 | 192.168.1.109 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.245.0  | 192.168.1.102 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 172.17.0.0    | 0.0.0.0       | 255.255.0.0     | U     | 0      | 0   | 0   | docker0         |
| 192.168.1.0   | 0.0.0.0       | 255.255.255.0   | U     | 0      | 0   | 0   | enp1s0          |
| 192.168.1.1   | 0.0.0.0       | 255.255.255.255 | UH    | 100    | 0   | 0   | enp1s0          |

#### `k8s-node007`

| Destination   | Gateway       | Genmask         | Flags | Metric | Ref | Use | Iface           |
| ------------- | ------------- | --------------- | ----- | ------ | --- | --- | --------------- |
| 0.0.0.0       | 192.168.1.1   | 0.0.0.0         | UG    | 100    | 0   | 0   | enp1s0          |
| 10.244.19.64  | 192.168.1.118 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.38.128 | 192.168.1.116 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.77.0   | 192.168.1.101 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.88.64  | 0.0.0.0       | 255.255.255.192 | U     | 0      | 0   | 0   | *               |
| 10.244.88.66  | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | calie16cab1a7bf |
| 10.244.88.192 | 192.168.1.109 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.245.0  | 192.168.1.102 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 172.17.0.0    | 0.0.0.0       | 255.255.0.0     | U     | 0      | 0   | 0   | docker0         |
| 192.168.1.0   | 0.0.0.0       | 255.255.255.0   | U     | 0      | 0   | 0   | enp1s0          |
| 192.168.1.1   | 0.0.0.0       | 255.255.255.255 | UH    | 100    | 0   | 0   | enp1s0          |

#### `k8s-node008`

| Destination   | Gateway       | Genmask         | Flags | Metric | Ref | Use | Iface   |
| ------------- | ------------- | --------------- | ----- | ------ | --- | --- | ------- |
| 0.0.0.0       | 192.168.1.1   | 0.0.0.0         | UG    | 100    | 0   | 0   | enp1s0  |
| 10.244.19.64  | 0.0.0.0       | 255.255.255.192 | U     | 0      | 0   | 0   | *       |
| 10.244.38.128 | 192.168.1.116 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0   |
| 10.244.77.0   | 192.168.1.101 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0   |
| 10.244.88.64  | 192.168.1.117 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0   |
| 10.244.88.192 | 192.168.1.109 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0   |
| 10.244.245.0  | 192.168.1.102 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0   |
| 172.17.0.0    | 0.0.0.0       | 255.255.0.0     | U     | 0      | 0   | 0   | docker0 |
| 192.168.1.0   | 0.0.0.0       | 255.255.255.0   | U     | 0      | 0   | 0   | enp1s0  |
| 192.168.1.1   | 0.0.0.0       | 255.255.255.255 | UH    | 100    | 0   | 0   | enp1s0  |


#### `k8s-node021`

| Destination   | Gateway       | Genmask         | Flags | Metric | Ref | Use | Iface           |
| ------------- | ------------- | --------------- | ----- | ------ | --- | --- | --------------- |
| 0.0.0.0       | 192.168.1.1   | 0.0.0.0         | UG    | 100    | 0   | 0   | eth0            |
| 10.244.19.64  | 192.168.1.118 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.38.128 | 192.168.1.116 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.77.0   | 0.0.0.0       | 255.255.255.192 | U     | 0      | 0   | 0   | *               |
| 10.244.77.6   | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | calia91eeb8f540 |
| 10.244.77.10  | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | calie1fb6eb68f2 |
| 10.244.77.11  | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | cali042270aa8f4 |
| 10.244.77.13  | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | calicf1c0b324f4 |
| 10.244.88.64  | 192.168.1.117 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.88.192 | 192.168.1.109 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.245.0  | 192.168.1.102 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 172.17.0.0    | 0.0.0.0       | 255.255.0.0     | U     | 0      | 0   | 0   | docker0         |
| 192.168.1.0   | 0.0.0.0       | 255.255.255.0   | U     | 0      | 0   | 0   | eth0            |
| 192.168.1.1   | 0.0.0.0       | 255.255.255.255 | UH    | 100    | 0   | 0   | eth0            |

#### `k8s-node022`

| Destination   | Gateway       | Genmask         | Flags | Metric | Ref | Use | Iface           |
| ------------- | ------------- | --------------- | ----- | ------ | --- | --- | --------------- |
| 0.0.0.0       | 192.168.1.1   | 0.0.0.0         | UG    | 100    | 0   | 0   | eth0            |
| 10.244.19.64  | 192.168.1.118 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.38.128 | 192.168.1.116 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.77.0   | 192.168.1.101 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.88.64  | 192.168.1.117 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.88.192 | 192.168.1.109 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.245.0  | 0.0.0.0       | 255.255.255.192 | U     | 0      | 0   | 0   | *               |
| 10.244.245.10 | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | calia81e8d854f2 |
| 10.244.245.11 | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | cali3ddaaf1723d |
| 10.244.245.12 | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | calic93b801bab9 |
| 172.17.0.0    | 0.0.0.0       | 255.255.0.0     | U     | 0      | 0   | 0   | docker0         |
| 192.168.1.0   | 0.0.0.0       | 255.255.255.0   | U     | 0      | 0   | 0   | eth0            |
| 192.168.1.1   | 0.0.0.0       | 255.255.255.255 | UH    | 100    | 0   | 0   | eth0            |


#### `k8s-node029`

| Destination   | Gateway       | Genmask         | Flags | Metric | Ref | Use | Iface           |
| ------------- | ------------- | --------------- | ----- | ------ | --- | --- | --------------- |
| 0.0.0.0       | 192.168.1.1   | 0.0.0.0         | UG    | 100    | 0   | 0   | enp1s0          |
| 10.244.19.64  | 192.168.1.118 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.38.128 | 192.168.1.116 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.77.0   | 192.168.1.101 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.88.64  | 192.168.1.117 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 10.244.88.192 | 0.0.0.0       | 255.255.255.192 | U     | 0      | 0   | 0   | *               |
| 10.244.88.199 | 0.0.0.0       | 255.255.255.255 | UH    | 0      | 0   | 0   | calid3399185bc1 |
| 10.244.245.0  | 192.168.1.102 | 255.255.255.192 | UG    | 0      | 0   | 0   | tunl0           |
| 172.17.0.0    | 0.0.0.0       | 255.255.0.0     | U     | 0      | 0   | 0   | docker0         |
| 192.168.1.0   | 0.0.0.0       | 255.255.255.0   | U     | 0      | 0   | 0   | enp1s0          |
| 192.168.1.1   | 0.0.0.0       | 255.255.255.255 | UH    | 100    | 0   | 0   | enp1s0          |

#### `k8s-master01`

| Destination | Gateway     | Genmask       | Flags | Metric | Ref | Use | Iface |
| ----------- | ----------- | ------------- | ----- | ------ | --- | --- | ----- |
| 0.0.0.0     | 192.168.1.1 | 0.0.0.0       | UG    | 0      | 0   | 0   | ens33 |
| 192.168.1.0 | 0.0.0.0     | 255.255.255.0 | U     | 0      | 0   | 0   | ens33 |

#### `k8s-master02`

| Destination | Gateway     | Genmask       | Flags | Metric | Ref | Use | Iface |
| ----------- | ----------- | ------------- | ----- | ------ | --- | --- | ----- |
| 0.0.0.0     | 192.168.1.1 | 0.0.0.0       | UG    | 0      | 0   | 0   | ens33 |
| 192.168.1.0 | 0.0.0.0     | 255.255.255.0 | U     | 0      | 0   | 0   | ens33 |

#### `k8s-master03`

| Destination | Gateway     | Genmask       | Flags | Metric | Ref | Use | Iface |
| ----------- | ----------- | ------------- | ----- | ------ | --- | --- | ----- |
| 0.0.0.0     | 192.168.1.1 | 0.0.0.0       | UG    | 0      | 0   | 0   | ens33 |
| 192.168.1.0 | 0.0.0.0     | 255.255.255.0 | U     | 0      | 0   | 0   | ens33 |