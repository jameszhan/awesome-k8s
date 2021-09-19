```bash
/
├── var
│   └── lib
│       ├── cni
│       │   ├── cache
│       │   │   └── results
│       │   ├── flannel
│       │   └── networks
│       │       └── cbr0
│       │           ├── 10.244.0.20
│       │           ├── last_reserved_ip.0
│       │           └── lock
│       ├── containerd
│       │   ├── io.containerd.content.v1.content
│       │   │   ├── blobs
│       │   │   └── ingest
│       │   ├── io.containerd.metadata.v1.bolt
│       │   │   └── meta.db
│       │   ├── io.containerd.runtime.v1.linux
│       │   ├── io.containerd.runtime.v2.task
│       │   │   └── moby
│       │   ├── io.containerd.snapshotter.v1.aufs
│       │   │   └── snapshots
│       │   ├── io.containerd.snapshotter.v1.btrfs
│       │   ├── io.containerd.snapshotter.v1.native
│       │   │   └── snapshots
│       │   ├── io.containerd.snapshotter.v1.overlayfs
│       │   │   └── snapshots
│       │   └── tmpmounts
│       ├── docker
│       │   ├── buildkit
│       │   │   ├── cache.db
│       │   │   ├── containerdmeta.db
│       │   │   ├── content
│       │   │   │   └── ingest
│       │   │   ├── executor
│       │   │   ├── metadata_v2.db
│       │   │   └── snapshots.db
│       │   ├── containers
│       │   ├── image
│       │   │   └── overlay2
│       │   │       ├── distribution
│       │   │       ├── imagedb
│       │   │       │   ├── content
│       │   │       │   │   └── sha256
│       │   │       │   └── metadata
│       │   │       │       └── sha256
│       │   │       ├── layerdb
│       │   │       │   ├── mounts
│       │   │       │   ├── sha256
│       │   │       │   └── tmp
│       │   │       └── repositories.json
│       │   ├── network
│       │   │   └── files
│       │   │       └── local-kv.db
│       │   ├── overlay2
│       │   ├── plugins
│       │   │   └── storage
│       │   │       └── ingest
│       │   ├── runtimes
│       │   ├── swarm
│       │   ├── trust
│       │   └── volumes
│       │       ├── backingFsBlockDev
│       │       └── metadata.db
│       ├── dockershim
│       │   └── sandbox
│       └──  kubelet
│            ├── config.yaml
│            ├── cpu_manager_state
│            ├── device-plugins
│            │   ├── DEPRECATION
│            │   └── kubelet.sock
│            ├── kubeadm-flags.env
│            ├── pki
│            │   ├── kubelet-client-2021-05-04-03-35-20.pem
│            │   ├── kubelet-client-current.pem
│            │   ├── kubelet.crt
│            │   └── kubelet.key
│            ├── plugins
│            ├── plugins_registry
│            ├── pod-resources
│            │   └── kubelet.sock
│            └── pods
├── run
│   ├── docker.sock
│   ├── dockershim.sock
│   ├── rpcbind.sock
│   ├── docker
│   │   ├── containerd
│   │   ├── libnetwork
│   │   ├── metrics.sock
│   │   ├── netns
│   │   ├── plugins
│   │   ├── runtime-runc
│   │   │   └── moby
│   │   └── swarm
│   └── containerd
│       ├── containerd.sock
│       ├── containerd.sock.ttrpc
│       ├── io.containerd.runtime.v1.linux
│       ├── io.containerd.runtime.v2.task
│       │   └── moby
│       └── s
└── usr
    └── bin
        ├── containerd
        ├── containerd-shim
        ├── containerd-shim-runc-v1
        ├── containerd-shim-runc-v2
        ├── crictl
        ├── ctr
        ├── docker
        ├── dockerd
        ├── dockerd-rootless-setuptool.sh
        ├── dockerd-rootless.sh
        ├── docker-init
        ├── docker-proxy
        ├── kubeadm
        ├── kubectl
        └── kubelet
```