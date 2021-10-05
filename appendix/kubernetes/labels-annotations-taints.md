## Well-Known Labels, Annotations and Taints

#### `kubernetes.io/arch`
- 示例：`kubernetes.io/arch=amd64`
- 用于：Node
> `Kubelet`用`Go`定义的`runtime.GOARCH`生成该标签的键值。在混合使用`arm`和`x86`节点的场景中，此键值可以带来极大便利。

#### `kubernetes.io/os`
- 示例：`kubernetes.io/os=linux`
- 用于：Node
> `Kubelet`用`Go`定义的`runtime.GOOS`生成该标签的键值。在混合使用异构操作系统场景下，此键值可以带来极大便利。

#### `kubernetes.io/metadata.name`
- 示例：`kubernetes.io/metadata.name=mynamespace`
- 用于：Namespaces
> 当`NamespaceDefaultLabelName`的`--feature-gates`启用时，`Kubernetes API`服务器会在所有命名空间上设置此标签。标签值被设置为命名空间的名称。 如果你想使用标签 选择器 来指向特定的命名空间，这很有用。

#### `kubernetes.io/hostname`
- 示例：`kubernetes.io/hostname=ip-172-20-114-199.ec2.internal`
- 用于：Node
> `Kubelet`用主机名生成此标签。需要注意的是主机名可修改，这是把“实际的”主机名通过参数`--hostname-override`传给`kubelet`实现的。

#### `controller.kubernetes.io/pod-deletion-cost`
- 示例：`controller.kubernetes.io/pod-deletion-cost=10`
- 用于：Pod
> 该注解用于设置`Pod`删除开销， 允许用户影响`ReplicaSet`的缩减顺序。该注解解析为`int32`类型。

#### `node.kubernetes.io/instance-type`
- 示例：`node.kubernetes.io/instance-type=m3.medium`
- 用于：Node
> `Kubelet`用`cloudprovider`定义的实例类型生成此标签。所以只有用到`cloudprovider`的场合，才会设置此标签。此标签非常有用，特别是在你希望把特定工作负载打到特定实例类型的时候，但更常见的调度方法是基于`Kubernetes`调度器来执行基于资源的调度。你应该聚焦于使用基于属性的调度方式，而尽量不要依赖实例类型（例如:应该申请一个`GPU`，而不是`g2.2xlarge`）。

#### `statefulset.kubernetes.io/pod-name`
- 示例：`statefulset.kubernetes.io/pod-name=mystatefulset-7`
> 当`StatefulSet`控制器为`StatefulSet`创建`Pod`时，控制平面会在该`Pod`上设置此标签。标签的值是正在创建的`Pod`的名称。

#### `topology.kubernetes.io/region`
- 示例：`topology.kubernetes.io/region=us-east-1`
- 参见：`topology.kubernetes.io/zone`

#### `topology.kubernetes.io/zone`
- 示例: `topology.kubernetes.io/zone=us-east-1c`
- 用于：Node, PersistentVolume
> Node场景：`kubelet`或外部的`cloud-controller-manager`用`cloudprovider`提供的信息生成此标签。所以只有在用到`cloudprovider`的场景下，此标签才会被设置。但如果此标签在你的拓扑中有意义，你也可以考虑在`node`上设置它。

> PersistentVolume场景：拓扑自感知的卷制备程序将在`PersistentVolumes`上自动设置节点亲和性限制。

#### `node.kubernetes.io/windows-build`
- 示例: `node.kubernetes.io/windows-build=10.0.17763`
- 用于：Node
> 当`kubelet`运行于`Microsoft Windows`，它给节点自动打标签，以记录`Windows Server`的版本。

#### `service.kubernetes.io/headless`
- 示例：`service.kubernetes.io/headless=""`
- 用于：Service
> 在`headless`服务的场景下，控制平面为`Endpoint`对象添加此标签。

#### `kubernetes.io/service-name`
- 示例：`kubernetes.io/service-name="nginx"`
- 用于：Service
> `Kubernetes`用此标签区分多个服务。当前仅用于`ELB(Elastic Load Balancer)`。

#### `endpointslice.kubernetes.io/managed-by`
- 示例：`endpointslice.kubernetes.io/managed-by="controller"`
- 用于：EndpointSlices
> 此标签用来指向管理`EndpointSlice`的控制器或实体。 此标签的目的是用集群中不同的控制器或实体来管理不同的`EndpointSlice`。

#### `endpointslice.kubernetes.io/skip-mirror`
- 示例：`endpointslice.kubernetes.io/skip-mirror="true"`
- 用于：Endpoints
> 此标签在`Endpoints`资源上设为`"true"`指示`EndpointSliceMirroring`控制器不要镜像此`EndpointSlices`资源。

#### `service.kubernetes.io/service-proxy-name`
- 示例：`service.kubernetes.io/service-proxy-name="foo-bar"`
- 用于：Service
> `kube-proxy`把此标签用于客户代理，将服务控制委托给客户代理。

#### `ingressclass.kubernetes.io/is-default-class`
- 示例：`ingressclass.kubernetes.io/is-default-class: "true"`
- 用于：IngressClass
> 当唯一的`IngressClass`资源将此注解的值设为`"true"`，没有指定类型的新`Ingress`资源将使用此默认类型。

#### `storageclass.kubernetes.io/is-default-class`
- 示例：`storageclass.kubernetes.io/is-default-class=true`
- 用于：StorageClass
> 当单个的`StorageClass`资源将这个注解设置为`"true"`时，新的持久卷申领`(PVC)`资源若未指定类别，将被设定为此默认类别。

#### `batch.kubernetes.io/job-completion-index`
- 示例：`batch.kubernetes.io/job-completion-index: "3"`
- 用于：Pod
> `kube-controller-manager`中的`Job`控制器给创建使用索引完成模式的`Pod`设置此注解。

#### `kubectl.kubernetes.io/default-container`
- 示例：`kubectl.kubernetes.io/default-container: "front-end-app"`
> 注解的值是此`Pod`的默认容器名称。 例如，`kubectl logs`或`kubectl exec`没有`-c`或`--container`参数时，将使用这个默认的容器。

#### `endpoints.kubernetes.io/over-capacity`
- 示例：`endpoints.kubernetes.io/over-capacity:warning`
- 用于：Endpoints
> 在`Kubernetes`集群`v1.21(或更高版本)`中，如果`Endpoint`超过`1000`个，`Endpoint`控制器 就会向其添加这个注解。该注解表示`Endpoint`资源已超过容量。

### 以下列出的污点只能用于Node

#### `node.kubernetes.io/not-ready`
- 示例：`node.kubernetes.io/not-ready:NoExecute`
> 节点控制器通过健康监控来检测节点是否就绪，并据此添加/删除此污点。

#### `node.kubernetes.io/unreachable`
- 示例：`node.kubernetes.io/unreachable:NoExecute`
> 如果 NodeCondition 的 Ready 键值为 Unknown，节点控制器将添加污点到 node。

#### `node.kubernetes.io/unschedulable`
- 示例：`node.kubernetes.io/unschedulable:NoSchedule`
> 当初始化节点时，添加此污点，来避免竟态的发生。

#### `node.kubernetes.io/memory-pressure`
- 示例：`node.kubernetes.io/memory-pressure:NoSchedule`
> `kubelet`依据节点上观测到的`memory.available`和`allocatableMemory.available`来检测内存压力。 用观测值对比`kubelet`设置的阈值，以判断节点状态和污点是否可以被添加/移除。

#### `node.kubernetes.io/disk-pressure`
- 示例：`node.kubernetes.io/disk-pressure:NoSchedule`
> `kubelet`依据节点上观测到的`imagefs.available`、`imagefs.inodesFree`、`nodefs.available`和`nodefs.inodesFree`(仅Linux)来判断磁盘压力。 用观测值对比`kubelet`设置的阈值，以确定节点状态和污点是否可以被添加/移除。

#### `node.kubernetes.io/network-unavailable`
- 示例：`node.kubernetes.io/network-unavailable:NoSchedule`
> 它初始由`kubectl`设置，云供应商用它来指示对额外网络配置的需求。仅当云中的路由器配置妥当后，云供应商才会移除此污点。

#### `node.kubernetes.io/pid-pressure`
- 示例：`node.kubernetes.io/pid-pressure:NoSchedule`
> `kubelet`检查`/proc/sys/kernel/pid_max`尺寸的D值(`D-value`)，以及节点上`Kubernetes`消耗掉的`PID`，以获取可用的`PID`数量，此数量可通过指标 `pid.available`得到。 然后用此指标对比`kubelet`设置的阈值，以确定节点状态和污点是否可以被添加/移除。

#### `node.cloudprovider.kubernetes.io/uninitialized`
- 示例：`node.cloudprovider.kubernetes.io/uninitialized:NoSchedule`
> 当`kubelet`由外部云供应商启动时，在节点上设置此污点以标记节点不可用，直到一个`cloud-controller-manager`控制器初始化此节点之后，才会移除此污点。

#### `node.cloudprovider.kubernetes.io/shutdown`
- 示例：`node.cloudprovider.kubernetes.io/shutdown:NoSchedule`
> 如果一个云供应商的节点被指定为关机状态，节点被打上污点`node.cloudprovider.kubernetes.io/shutdown`，污点的影响为`NoSchedule`。