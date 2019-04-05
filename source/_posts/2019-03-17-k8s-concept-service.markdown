---
layout: post
title: "K8s之Service"
date: 2019-03-17 20:45
comments: true
keywords: K8s
description: K8s
categories: K8s
published: true
---

### 如何访问Pod？

在非k8s世界中，管理员可以通过在配置文件中指定IP地址或主机名，容许客户端访问，但在k8s中这种方式是行不通的。因为Pod 是有生命周期的，它们可以被创建或销毁。虽然通过 ReplicationController 能够动态地创建Pod，但当Pod被分配到某个节点时，K8s都会为其分配一个IP地址，而该IP地址不总是稳定可依赖的。因此，在 Kubernetes 集群中，如果一组 Pod（称为 backend）为其它 Pod （称为 frontend）提供服务，那么那些 frontend 该如何发现，并连接到这组backend的Pod呢？

<!-- More -->

### Service

Kubernetes中的Service是一种资源的定义，它将Pod逻辑分组，并提供客户端访问。

<img src="{{ root_url }}/images/k8s/k8s-service-1.png" />

 通过 Label Selector，一组 Pod 能够被暴露为Service，供客户端访问。

 <img src="{{ root_url }}/images/k8s/k8s-service-2.png" />


举个例子，考虑一个图片处理 backend，它运行了3个副本。这些副本是可互换的，通过Service能够解耦frontend与backend的关联。
> frontend 不需要关心它们调用了哪个 backend 副本。 然而组成这一组 backend 程序的 Pod 实际上可能会发生变化，frontend 客户端不应该也没必要知道，而且也不需要跟踪这一组 backend 的状态。

### 创建Service
一个 Service 在 Kubernetes 中是一个 REST 对象，和 Pod 类似。 像所有的 REST 对象一样， Service 定义可以基于 POST 方式，请求 apiserver 创建新的实例。 例如，假定有一组 Pod，它们对外暴露了 9376 端口，同时还被打上 "app=MyApp" 标签。

```yaml
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
  selector:
    app: MyApp            //根据Label选择一组Pod
  ports:
    - protocol: TCP
      port: 80            //用于访问该Service的端口
      targetPort: 9376    //用于访问容器的端口
```

接下来，我们可以使用```kubectl```访问该Service

<img src="{{ root_url }}/images/k8s/k8s-service-3.png" />

### Service如何被外部网络的Client访问

可以通过如下三种方式，容许外部网络的Client访问Service：

#### 1.将Service Type置为```NodePort```

对于NotePort的Service，每个节点(Node)都会打开节点本身的端口，并将该端口上接收到的流量重定向到Service。

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kubia-nodeport
spec:
  type: NodePort             //NodePort类型
  ports:
  - port: 80                 //Service内部访问的地址
    targetPort: 8080         //转发给目标Pod的地址
    nodePort: 30123          //可访问的nodeport端口
  selector:
    app: kubia
```    

使用NodePort的Service如下图所示：
<img src="{{ root_url }}/images/k8s/k8s-service-4.png" />

#### 2.将Service Type设置为```LoadBalancer```

通过设置```LoadBalancer```，Service可以通过一个专用的负载均衡器来访问（这个均衡器是运行kubernetes的基础设施提供的）。负载均衡器将流量重定向到所有节点上的节点端口。客户机通过负载均衡器的IP连接到服务。

如果kubernetes在不支持LoadBalancer服务的环境中运行，则不会提供负载均衡器，但该服务的行为仍将类似于NodePort服务。

```yaml

apiVersion: v1
kind: Service
metadata:
  name: kubia-loadbalancer
spec:
  type: LoadBalancer                
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: kubia
```    

使用如上配置文件创建Service之后，会调用云基础设施，创建负载均衡器并将其IP地址写入Service对象。一旦结束，IP地址将作为Service的外部IP地址列出：

如下图所示：
<img src="{{ root_url }}/images/k8s/k8s-service-5.png" />

#### 3.使用```Ingress```资源

这是一种完全不同的机制，通过一个IP地址公开多个服务，它在HTTP（网络层7）上运行，因此可以提供比第4层服务更多的功能。

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: kubia
spec:
  rules:
  - host: kubia.example.com               //使用domain name访问service
    http:
      paths:
      - path: /                           //访问的路径
        backend:
          serviceName: kubia-nodeport     
          servicePort: 80                 
```

通过Ingress访问Service的流程如下：

<img src="{{ root_url }}/images/k8s/k8s-service-7.png" />

另外，可以通过Ingress访问多个服务：

```yaml
...
  - host: kubia.example.com
    http:
      paths:
      - path: /kubia                
        backend:                    
          serviceName: kubia        
          servicePort: 80           
      - path: /foo                  
        backend:                    
          serviceName: bar          
          servicePort: 80           
```
<img src="{{ root_url }}/images/k8s/k8s-service-6.png" />


### Service的诊断

Service是Kubernetes的关键概念，也是令许多开发人员沮丧的根源。我见过许多开发人员耗费大量时间，来弄清楚为什么无法通过Servic IP或fqdn访问到自己的pods。
出于这个原因，简单介绍一下如何对服务进行故障排除。当无法通过Service访问您的pod时，可以从以下列表开始：

* 首先，确保从集群内而不是从外部连接到Service的集群IP。

* 不要费心Ping Service的IP来确定服务是否可以访问（记住，服务的集群IP是一个虚拟IP，Ping它永远不会工作）。

* 如果您已经定义了一个readiness probe，请确保它是成功的；否则Pod将不属于服务的一部分。

* 要确认Pod是服务的一部分，请使用kubectl get endpoints检查相应的endpoint对象。

* 如果您试图通过其fqdname或其一部分（例如，myservice.mynamespace.svc.cluster.local或myservice.mynamespace）访问服务，但该服务不起作用，请查看是否可以使用其群集IP而不是fqdname访问该服务。

* 检查您是否连接到服务公开的端口，而不是目标端口。

* 尝试直接连接到pod ip以确认pod是否接受正确端口上的连接。

* 如果你甚至不能通过pod的IP访问你的应用，确保你的应用是否绑定到locahost。

### 总结

Service是K8s中重要的概念，你应该至少明白Service的这些内容：

* 通过Lable selector，将一组Pod设置为Service，并为Service配置静态的IP和端口

* Service可以从Cluster内部访问，也可以通过设置为NodePort或者LoadBalancer的方式从外部访问

* Pod可以通过环境变量获取Service的IP和Port，进行访问

* 可以将对Pod的关联关系，设置到Endpoint资源中，而简化label selector的方式

* 通过设置ServiceType为```ExternalName```，可以访问外部的Service

* 通过Ingress可以设置多个Service被外部访问

* 使用pod的readiness probe可以决定pod是否被作为service的一部分

* 通过headless Service，可以使用DNS获取Pod的IP

### 参考

《Kubernetes in action》
《Kubernetes handbook》
