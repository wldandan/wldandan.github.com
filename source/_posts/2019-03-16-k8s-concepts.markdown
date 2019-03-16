---
layout: post
title: "K8s核心概念"
date: 2019-03-15 23:45
comments: true
keywords: K8s
description: K8s
categories: K8s
published: true
---

### 综述

Paxos发明人Leslie Lamport的理念是分布式系统有两类特性：

* 安全性(Safety)
保证系统的稳定，保证系统不会崩溃，不会出现业务错误，不会做坏事，是严格约束的。

* 活性(Liveness)
使得系统可以提供功能，提高性能，增加易用性，让系统可以在用户“看到的时间内”做些好事，是尽力而为的。


从Kubernetes的系统架构和设计来看，存在两个最核心的设计理念，也符合Lamport的经典理论：

* 容错性
容错性实际是保证Kubernetes系统稳定性和安全性的基础

* 易扩展性
易扩展性是保证对变更友好，可以快速迭代增加新功能的基础

在K8S核心设计理念的背后，存在着诸多领域对象，支撑这些核心理念的实现。

本文主要梳理了K8S系统中的主要概念。


<!-- More -->

#### 1.核心概念

##### Pod
> Pod是在Kubernetes集群中运行部署应用或服务的最小单元，它是可以支持多容器的。Pod的设计理念是支持多个容器在一个Pod中共享网络地址和文件系统，可以通过进程间通信和文件共享这种简单高效的方式组合完成服务。
目前Kubernetes中的业务主要可以分为长期伺服型（long-running）、批处理型（batch）、后台支撑型（node-daemon）和有状态应用型（stateful application）；分别对应的控制器为Deployment、Job、DaemonSet和StatefulSet，

##### 部署（Deployment）
> 部署表示用户对Kubernetes集群的一次更新操作。部署是一个比RS应用模式更广的API对象，可以是创建一个新的服务，更新一个新的服务，也可以是滚动升级一个服务。滚动升级一个服务，实际是创建一个新的RS，然后逐渐将新RS中副本数增加到理想状态。以Kubernetes的发展方向，未来对所有长期伺服型的的业务的管理，都会通过Deployment来管理。

##### 服务（Service）
> RC、RS和Deployment只是保证了支撑服务的微服务Pod的数量，但是没有解决如何访问这些服务的问题。一个Pod只是一个运行服务的实例，随时可能在不同节点上停止或者启动，因此不能确定其IP和端口号提供服务。那谁来稳定地提供`服务发现`和`负载均衡`的能力呢？在K8集群中，客户端要访问的服务就是Service对象。
> 每个Service会对应一个集群内部有效的虚拟IP，集群内部通过虚拟IP访问服务。
> 在K8集群中微服务的负载均衡是由Kube-proxy实现的。Kube-proxy是Kubernetes集群内部的负载均衡器。它是一个分布式代理服务器，在Kubernetes的每个节点上都有一个。这一设计体现了它的伸缩性优势，需要访问服务的节点越多，提供负载均衡能力的Kube-proxy就越多，高可用节点也随之增多。

##### 节点（Node）
> Kubernetes集群中的计算能力由Node提供，最初Node称为服务节点Minion，后来改名为Node。Kubernetes集群中的Node也就等同于Mesos集群中的Slave节点，是所有Pod运行所在的工作主机，可以是物理机也可以是虚拟机。不论是物理机还是虚拟机，工作主机的统一特征是上面要运行kubelet管理节点上运行的容器。

##### 命名空间（Namespace）
> 命名空间为Kubernetes集群提供虚拟的隔离作用，Kubernetes集群初始有两个命名空间，分别是默认命名空间default和系统命名空间kube-system，除此以外，管理员可以可以创建新的命名空间满足需要。

##### 任务(Job)
> Job是Kubernetes用来控制批处理型任务的API对象。批处理业务与长期伺服业务的主要区别是批处理业务的运行有头有尾，而长期伺服业务在用户不停止的情况下永远运行。Job管理的Pod把任务成功完成就自动退出了。成功完成的标志根据不同的spec.completions策略而不同：单Pod型任务有一个Pod成功就标志完成；多任务的成功保证有N个任务全部执行成功；工作队列型任务根据应用确认的全局成功而标志成功。


#### 2.管理与支撑概念

##### API
> API对象是Kubernetes集群中的管理操作单元。Kubernetes集群系统每支持一项新功能，引入一项新概念，一定会新引入对应的API对象，支持对该功能的管理操作。例如副本集Replica Set对应的API对象是RS。
每个API对象都有3大类属性：元数据metadata、规范spec和状态status


##### 副本控制器（Replication Controller，RC）
> RC是Kubernetes集群中最早的保证Pod高可用的API对象。通过监控运行中的Pod来保证集群中运行指定数目的Pod副本。

##### 副本集（Replica Set，RS)
> RS是新一代RC，提供同样的高可用能力，区别主要在于RS后来居上，能支持更多种类的匹配模式。副本集对象一般不单独使用，而是作为Deployment的理想状态参数使用。


##### 后台支撑服务集（DaemonSet）
> 长期伺服型和批处理型服务的核心在业务应用，可能有些节点运行多个同类业务的Pod，有些节点上又没有这类Pod运行；而后台支撑型服务的核心关注点在Kubernetes集群中的节点（物理机或虚拟机），要保证每个节点上都有一个此类Pod运行。节点可能是所有集群节点也可能是通过nodeSelector选定的一些特定节点。典型的后台支撑型服务包括，存储，日志和监控等在每个节点上支持Kubernetes集群运行的服务。

##### 有状态服务集（StatefulSet）
> 在云原生应用的体系里，有下面两组近义词；第一组是无状态（stateless）、牲畜（cattle）、无名（nameless）、可丢弃（disposable）；第二组是有状态（stateful）、宠物（pet）、有名（having name）、不可丢弃（non-disposable）
> RC和RS主要是控制提供无状态服务的，其所控制的Pod的名字是随机设置的，一个Pod出故障了就被丢弃掉，在另一个地方重启一个新的Pod，名字变了和启动在哪儿都不重要，重要的只是Pod总数；而StatefulSet是用来控制有状态服务，StatefulSet中的每个Pod的名字都是事先确定的，不能更改。
> 对于RC和RS中的Pod，一般不挂载存储或者挂载共享存储，保存的是所有Pod共享的状态，Pod像牲畜一样没有分别（这似乎也确实意味着失去了人性特征）；对于StatefulSet中的Pod，每个Pod挂载自己独立的存储，如果一个Pod出现故障，从其他节点启动一个同样名字的Pod，要挂载上原来Pod的存储继续以它的状态提供服务。
> 适合于StatefulSet的业务包括数据库服务MySQL和PostgreSQL，集群化管理服务ZooKeeper、etcd等有状态服务。使用StatefulSet，Pod仍然可以通过漂移到不同节点提供高可用，而存储也可以通过外挂的存储来提供高可靠性，StatefulSet做的只是将确定的Pod与确定的存储关联起来保证状态的连续性。


##### 集群联邦（Federation）
> 在云计算环境中，服务的作用距离范围从近到远一般可以有：同主机（Host，Node）、跨主机同可用区（Available Zone）、跨可用区同地区（Region）、跨地区同服务商（Cloud Service Provider）、跨云平台。Kubernetes的设计定位是单一集群在同一个地域内，因为同一个地区的网络性能才能满足Kubernetes的调度和计算存储连接要求。而联合集群服务就是为提供跨Region跨服务商Kubernetes集群服务而设计的。
> 每个Kubernetes Federation有自己的分布式存储、API Server和Controller Manager。用户可以通过Federation的API Server注册该Federation的成员Kubernetes Cluster。当用户通过Federation的API Server创建、更改API对象时，Federation API Server会在自己所有注册的子Kubernetes Cluster都创建一份对应的API对象。在提供业务请求服务时，Kubernetes Federation会先在自己的各个子Cluster之间做负载均衡，而对于发送到某个具体Kubernetes Cluster的业务请求，会依照这个Kubernetes Cluster独立提供服务时一样的调度模式去做Kubernetes Cluster内部的负载均衡。而Cluster之间的负载均衡是通过域名服务的负载均衡来实现的。

#### 3.用户与权限概念

##### 用户帐户（User Account）
> 用户帐户为人提供账户标识，对应的是人的身份，人的身份与服务的namespace无关，所以用户账户是跨namespace的

##### 服务帐户（Service Account）
> 服务账户为计算机进程和Kubernetes集群中运行的Pod提供账户标识。服务帐户对应的是一个运行中程序的身份，与特定namespace是相关的。

##### 密钥对象（Secret）
> Secret是用来保存和传递密码、密钥、认证凭证这些敏感信息的对象。为了避免将类似的敏感信息明文写在配置文件中，可以将其存入一个Secret对象，并在配置文件中通过Secret对象引用这些敏感信息

##### RBAC访问授权
> RBAC主要是引入了角色（Role）以及与角色绑定（RoleBinding）的相关抽象概念。

### 参考资料
[《Kubernetes 与云原生应用》系列之 Kubernetes 的系统架构与设计理念](https://infoq.cn/article/kubernetes-and-cloud-native-applications-part01)
