---
layout: post
title: "K8s之Volume"
date: 2019-04-05 21:04
comments: true
keywords: K8s
description: K8s
categories: K8s
published: true
---

本篇文章主要介绍在K8S中，pod的容器如何访问外部磁盘存储，以及容器间如何实现共享存储，主要内容包括

* 通过volume和emptyDir在容器中共享数据
* 在Pod中使用Git Repo
* 使用外部存储，如GCE
* 使用PV(PersistentVolume)和PVC(PersistentVolumeClaim)

<!--More-->

#### 一. 使用emptyDir
最简单的卷类型是emptyDir。顾名思义，emptyDir是从空目录开始。在pod中运行的应用程序可以向它写入任何文件。因为emptyDir卷的生命周期与pod的生命周期相关联，所以当pod被删除时，卷的内容会丢失。

emptyDir卷对于在同一个pod中运行的容器间共享文件特别有用。

```yaml

apiVersion: v1
kind: Pod
metadata:
  name: fortune
spec:
  containers:
  - image: luksa/fortune                   1
    name: html-generator                   1
    volumeMounts:                          2
    - name: html                           2
      mountPath: /var/htdocs               2
  - image: nginx:alpine                    3
    name: web-server                       3
    volumeMounts:                          4
    - name: html                           4
      mountPath: /usr/share/nginx/html     4
      readOnly: true                       4
    ports:
    - containerPort: 80
      protocol: TCP
  volumes:                                 5
  - name: html                             5
    emptyDir: {}                           5

```
> 1. 第1个容器名为```html-generator```，其镜像为```luksa/fortune```
> 2. volume的名称是```html```，其在容器中的路径为```/var/htdocs```
> 3. 第2个容器为```web-server```，镜像为```nginx:alpine```
> 4. 第2个容器使用的卷为```html```，加载到```/usr/share/nginx/html```
> 5. volume名称为```name```，emptyDir初始为为空

默认情况下，emptyDir使用Node的磁盘，但是你也可以使用内存，类似如下：
```yaml
volumes:
  - name: html
    emptyDir:
      medium: Memory              
```      

#### 二. 使用Git Repo

Git Repo卷基本上是基于emptyDir，通过克隆Git仓库并在pod启动时（但在创建其容器之前）签出特定版本。如图6.3所示:

<img src="{{ root_url }}/images/k8s/k8s-volume-gitrepo.png" />

示例代码如下所示：
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gitrepo-volume-pod
spec:
  containers:
  - image: nginx:alpine
    name: web-server
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
      readOnly: true
    ports:
    - containerPort: 80
      protocol: TCP
  volumes:
  - name: html
    gitRepo:  
      repository: https://github.com/luksa/kubia-website-example.git
      revision: master   
      directory: .       
```

默认情况下，使用gitrepo卷存在一个缺点，它不会与所引用的git repo保持同步。只有当pod重启或者创建一个新pod时，才会从Got仓库获取最新的内容。

#### 三. 使用hostPath

hostPath是一种持久性存储，它指向Node文件系统中的目录，如下图所示。

运行在同一节点上的Pod，如果使用相同的hostPath卷，则可以彼此访问相同的文件。

<img src="{{ root_url }}/images/k8s/k8s-volume-hostpath.png" />

使用hostPath的方式如下所示：

```yaml

Volumes:
  varlog:
    Type:       HostPath (bare host directory volume)
    Path:       /var/log
  varlibdockercontainers:
    Type:       HostPath (bare host directory volume)
    Path:       /var/lib/docker/containers

```

当一个pod被删除时，gitrepo和emptydir卷的内容都会被删除，但hostPath卷的内容不会。对于在某Node上创建的新pod，如果设置hostPath卷与之前pod的路径一致，那么它能也能访问到之前Pod写入的数据。

但是，如果您考虑使用hostPath作为数据库数据目录的话，请谨慎考虑。因为卷的内容存储在特定Node的文件系统中，当数据库pod被重新调度到另一个节点时，数据将无法被看到。


#### 四. 使用网络文件存储
对于网络存储而言，可以使用GCE Persistent Disk、AWS Elastic BlockStore、Azure File、Azure Disk。

譬如，使用GCE Persisteng Disk的方式如下所示：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mongodb
spec:
  volumes:
  - name: mongodb-data           1
    gcePersistentDisk:           1
      pdName: mongodb            1
      fsType: ext4               1
  containers:
  - image: mongo
    name: mongodb
    volumeMounts:
    - name: mongodb-data         2
      mountPath: /data/db        2
    ports:
    - containerPort: 27017
      protocol: TCP
```
> 1. 使用GCE Persistent Disk.
> 2. 使用GCE Persistent Disk，挂载到/data/db上

#### 五. 自建文件系统存储

除此之外，也可以使用自建的文件系统，如
NFS、iscsi(ISCSI disk)、glusterfs(GlusterFS), rbd(RADOS Block Device), flexVolume, cinder, cephfs, flocker, fc (Fibre Channel)等


#### 六. 如何将Pod与存储机制解耦

到目前为止，所有持久卷类型都要求POD的开发人员了解集群实际的网络存储基础结构。例如，要创建一个支持NFS的卷，开发人员必须知道NFS所在的实际服务器。这与Kubernetes的基本理念背道而驰，Kubernetes的目标是对应用程序及其开发人员透明化其背后的基础设施，使他们不必关心基础设施的具体情况，也不必让应用程序在各种云提供商和内部数据中心之间实现数据的移植。

理想情况下，在Kubernetes上部署应用程序的开发人员不必知道底层使用的是哪种存储技术，就像他们不必知道运行其pod所使用的物理服务器类型一样。当开发人员需要为他们的应用程序提供持久化的存储时，他们应该直接能够配置，就像在创建pod时配置CPU、内存和其他资源一样。

为了使应用程序能够在Kubernetes集群中请求存储，而不必处理基础设施的具体细节，K8S引入了两种新的资源:

* PersistentVolumes
* PersistentVolumeClaims

使用方式如下所示:

<img src="{{ root_url }}/images/k8s/k8s-volume-pv-and-pvc.png" />

如图所示，开发人员不需要在pod中使用特定的存储机制，集群管理员设置底层存储，然后通过kubernetes创建PV，并且指定其大小和支持的访问模式。

当开发人员需要在pod中使用持久存储时，他们首先创建一个PVC清单，指定所需的大小和访问模式。然后用户将PVC清单提交给kubernetes ，kubernetes找到适当的PV并将其绑定到PV上。

当使用了PV和PVC后，使用GCE Persisent Disk的机制如下所示：

<img src="{{ root_url }}/images/k8s/k8s-volume-pv-vs-volume.png" />


总而言之，在pod中使用持久性存储的最佳方法是创建pvc（必要时使用显式指定的storageclassname），并由动态PersistentVolume Provider负责创建。

####总结

在K8S中使用存储机制总结如下：

* 使用EmptyDir卷存储临时的非持久性数据
* 使用gitrepo卷在pod启动时获取git存储库的内容。
* 使用hostpath卷访问主机节点的文件
* 在volume中挂在外部存储，在pod启动后保持数据
* 通过使用persistentvolume和persistentvolumeclaims将pod与存储基础结构分离
