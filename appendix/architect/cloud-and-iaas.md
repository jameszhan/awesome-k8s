###  IaaS平台

私有云的解决方案主要有:
- [VMware vSphere](https://www.vmware.com): 基于`VMware`虚拟化技术的虚拟化管理软件，目前是行业内最成熟、生产环境应用度最广的`IaaS`层虚拟化技术商用解决方案，目前对整个集群的虚拟机监控管理也是最好的。
- [Openstack](https://www.openstack.org/): 基于`Linux`的`IaaS`层解决方案，是目前用户最多、影响最大的开源解决方案，国内的虚拟化解决方案大部分是基于Openstack开发定制的，主要运行在CentOS和Ubuntu操作系统上。
- [CloudStack](http://cloudstack.apache.org): 是使用`Java`开发的基于`Linux`的`IaaS`层解决方案。`CloudStack`是一个高可用性及扩展性的开源云计算平台，同时也是一个开源云计算解决方案，可以加速具有高伸缩性的公共和私有云（`IaaS`）的部署、管理、配置。

### 云管理平台

#### 01.自建托管式容器平台
> 自建托管式容器环境就是基于容器技术和调度统筹框架的自建云平台管理环境。
- [Kubernetes](https://kubernetes.io): 来自谷歌云平台的开源容器集群管理系统。基于`Docker`构建一个容器的调度服务。该系统可以自动在一个容器集群中选择一个工作容器供使用。其核心概念是`Container Pod`。
- [Docker Swarm](https://docs.docker.com/swarm/): `Docker`公司发布的`Docker Swarm`用来提供容器集群服务，其目的是更好地帮助用户管理多个`Docker Engine`。`Docker Swarm`通过把多个`Docker Engine`聚集在一起，形成一个大的`docker-engine`，对外提供容器的集群服务。
- [Rancher](https://www.cnrancher.com): 一个开源的企业级全栈化容器部署及管理平台。通过`Web`界面管理`Docker`容器的平台，定位上和`K8S`比较接近，都是通过`Web`界面赋予完全的`Ddocker`服务编排功能。平台部署、扩展和服务部署方便，自带账户权限。
- [UFleet](http://www.youruncloud.com/ufleet.html): `UFleet`是以`Kubernetes`为基础、以应用为中心、以安全、稳定、简洁为宗旨的企业级容器云平台，帮助企业快速实现基于容器的`DevOps`、`CI/CD`、`PaaS`云平台、大数据云平台等。帮助企业构建应用商店，以应用为中心，可秒级部署、一键升级。

#### 02.容器管理系统
> 容器管理系统是对容器进行编排、整合以及管理平台等，下面列举部分容器管理系统。
- [OpenShift](https://www.openshift.com): `OpenShift`平台是由`RedHat`推出的一款面向开源开发人员的平台。`OpenShift`通过为开发人员提供在语言、框架和云上的更多选择，帮助他们构建、测试、运行和管理应用。
- [Docker EE](https://docs.docker.com/ee/): `Docker`企业版是一个高可用的容器云平台，可在客户拥有多版本`Linux`、多操作系统和多种云的复杂环境下来管理和保护`Kubernetes`上的应用程序。`Docker EE`为企业提供编排工具（`Kubernetes`和`Swarm`）、应用程序（遗留或云原生）以及基础设施（云或本地）等功能。
- [微软的Deis](https://azure.microsoft.com/zh-cn/services/kubernetes-service/): 其主要开发项围绕`Kubernetes`的各种开放源码工具，协助团队构建及管理各种基于`Kubernetes`的应用程序。
- [Apache Mesos](http://mesos.apache.org): `Apache Mesos`是一个集群管理器，提供了有效的、跨分布式应用或框架的资源隔离和共享，可以运行`Hadoop`、`MPI`、`Hypertable`、`Spark`。

#### 03.托管式容器云服务
> 托管式容器云服务有谷歌`Container Engine`、微软`Azure`容器服务等。下面列举部分托管式容器云服务：
- [谷歌Container Engine](https://www.openshift.com): 谷歌推出的容器集群管理服务。谷歌`Container Engine`本身基于谷歌的开源项目`Kubernetes`，容器管理软件由谷歌技术团队开发，并以开源的形式发布。
- [亚马逊Elastic Container Service(Amazon ECS)](https://www.cloudfoundry.org): 一种高度可扩展的高性能容器编排服务，支持`Docker`容器，提供扩展容器化应用程序、容器编排软件、扩展虚拟机集群、虚拟机上调度容器等。通过各种简单的`API`调用，可以使用`Docker`的应用程序、`IAM`角色、安全组、负载均衡器、亚马逊`CloudWatch Events`、`AWS CloudFormation`模板和`AWS CloudTrail`日志等多种常用功能。
- 微软`Azure`容器服务: 微软Azure容器服务可轻松创建、配置和管理虚拟机群集，这些虚拟机已经过预配置，可以运行容器化应用程序。通过此服务，用户可使用现有技能或利用不断增加的大量社区专业知识，在微软Azure上部署和管理基于容器的应用程序（官网地址：https://azure.microsoft.com/zh-cn/services/kubernetes-service/）。

#### 04.PaaS框架管理平台
`PaaS`框架管理平台基于`PaaS`框架及其上面的管理平台，下面列举部分`PaaS`框架管理平台。
- [Cloud Foundry](https://www.cloudfoundry.org)——`Cloud Foundry`是`VMware`推出的业界第一个开源PaaS云平台，它支持多种框架、语言、运行时环境、云平台及应用服务，使开发人员能够在几秒内进行应用程序的部署和扩展，无须担心任何基础架构的问题。
- [OpenShift Origin](https://github.com/openshift/origin)——`OpenShift Origin`是一个云服务平台（`PaaS`），它是`OpenShift`的开源社区支持版本。
- [Bluemix](https://console.bluemix.net)——`IBM`的`Bluemix`云计算平台基于 PaaS 云来帮助开发者更快地进行应用开发和部署。`Bluemix`平台基于开源的`Cloud Foundry`技术，涵盖目前广泛采用的主流开发语言支持、数据库支持，以及`IBM`自家的技术`API`。
- Heroku——在2010年被Salesforce.com收购。Heroku作为最早的云平台之一，支持Ruby、Java、Node.js、Scala、Clojure、Python 以及 PHP和Perl 等开发语言。基础操作系统是Debian，在最新的堆栈中则是基于Debian的Ubuntu操作系统（官网地址：https://www.heroku.com/）。

#### 05.`Serverless`平台
无服务器平台有`AWS Serverless Platform`等，列举如下。
- [`AWS Serverless Platform`](https://aws.amazon.com/cn/serverless/)——`AWS`的无服务器计算和应用程序，可在不考虑服务器的情况下构建并运行应用程序。
- 微软`Azure Functions`——微软`Azure Functions`支持一系列可靠的事件触发器和数据绑定，使用`Azure Functions`可以按需运行代码，而无须显式预配或管理基础结构，也可以运行脚本或代码片段，以响应各种事件。`Azure Functions`基于在`Azure App Service PaaS`中使用的WebJobs软件开发工具包，有助于用户将应用或脚本程序作为Web或移动应用的一部分来运行。
- 谷歌`Cloud Functions`——谷歌`Cloud Functions`是构建和连接云服务的、基于事件驱动的无服务器执行环境。谷歌Cloud Functions具有自动扩展、运行代码以响应事件的能力，并且不需要任何服务器管理。用例包括无服务器应用程序后端、实时数据处理和智能应用程序，如虚拟助手，聊天机器人和情绪分析等。
- 阿里`Function Compute`框架——阿里`Function Compute`是一个事件驱动的全托管计算服务，是国内首个事件驱动的无服务器计算平台。

> 注: 上述描述来自于《微服务设计：企业架构转型之道》（2019），相关描述已经过时。
