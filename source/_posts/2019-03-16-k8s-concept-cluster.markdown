---
layout: post
title: "K8s之集群"
date: 2019-03-15 21:45
comments: true
keywords: K8s
description: K8s
categories: K8s
published: true
---

为了管理异构和不同配置的主机，为了便于Pod的运维管理，Kubernetes中提供了很多集群管理的配置和管理功能，通过namespace划分的空间，通过为node节点创建label和taint用于pod的调度等。

<!-- More -->

### Node

Node是kubernetes集群的工作节点，可以是物理机也可以是虚拟机。

##### Node的状态:

* Address
	* HostName：可以被kubelet中的--hostname-override参数替代。
	* ExternalIP：可以被集群外部路由到的IP地址。
	* InternalIP：集群内部使用的IP，集群外部无法访问。

* Condition
	* OutOfDisk：磁盘空间不足时为True
	* Ready：Node controller 40秒内没有收到node的状态报告为Unknown，健康为True，否则为False。
	* MemoryPressure：当node没有内存压力时为True，否则为False。
	* DiskPressure：当node没有磁盘压力时为True，否则为False。

* Capacity
	* CPU
	* 内存
	* 可运行的最大Pod个数

* Info：节点的一些版本信息，如OS、kubernetes、docker等

### Namespace

在一个Kubernetes集群中可以使用namespace创建多个“虚拟集群”，这些集群之间可以完全隔离。如当项目和人员众多的时候可以考虑根据项目属性，例如生产、测试、开发划分不同的namespace。


另外，也可以让一个namespace中的service访问到其他的namespace中的服务。

### Label & Annonication

Label是附在对象上（例如Pod）的键值对。可以在创建对象的时候指定，也可以在对象创建后随时指定。Labels的值对系统本身并没有什么含义，只是对用户有意义。通过label selector，客户端／用户可以指定一个object集合，通过label selector对object的集合进行操作。

Annotation,可以将Kubernetes资源对象关联到任意的非标识性元数据。使用客户端（如工具和库）可以检索到这些元数据。

Label和Annotation都可以将元数据关联到Kubernetes资源对象。Label主要用于选择对象，可以挑选出满足特定条件的对象。相比之下，annotation 不能用于标识及选择对象。annotation中的元数据可多可少，可以是结构化的或非结构化的，也可以包含label中不允许出现的字符。


