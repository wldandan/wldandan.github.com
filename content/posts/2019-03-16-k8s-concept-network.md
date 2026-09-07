---
title: "K8s之网络"
date: 2019-03-15T23:45:00+08:00
comments: true
keywords: K8s
description: K8s

categories: ["K8s"]
url: /blog/2019/03/15/k8s-concept-network/
---

K8s的网络介绍

<!--more-->

### K8s集群IP

Kubernetes集群内部存在三类IP，分别是：

* Node IP：宿主机的IP地址
* Pod IP：使用网络插件创建的IP（如flannel），使跨主机的Pod可以互通
* Cluster IP：虚拟IP，通过iptables规则访问服务
