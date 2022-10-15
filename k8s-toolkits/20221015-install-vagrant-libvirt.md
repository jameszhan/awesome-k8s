# Install Vagrant with Libvirt

## Install Vagrant

```bash
$ wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
$ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list
$ sudo apt update && sudo apt install vagrant=2.3.0

$ vagrant version
Installed Version: 2.3.0
Latest Version: 2.3.1

$ sudo apt-mark hold vagrant
$ sudo apt-mark showhold

$ vagrant global-status
```

## Install vagrant-libvirt plugin

```bash
# 打开deb-src源
$ sudo sed -i '/deb-src/s/^# //' /etc/apt/sources.list

$ sudo apt update && sudo apt build-dep -y libvirt ruby-libvirt
$ sudo apt install -y --no-install-recommends \
        libxslt-dev \
        libxml2-dev \
        libvirt-dev \
        ruby-bundler \
        ruby-dev \
        zlib1g-dev;
        
$ vagrant plugin install vagrant-libvirt
$ vagrant plugin list
vagrant-libvirt (0.10.8, global)
```