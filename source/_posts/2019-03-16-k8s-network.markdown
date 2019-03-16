---
layout: post
title: "K8s之网络"
date: 2019-03-15 23:45
comments: true
keywords: K8s
description: K8s
categories: K8s
published: true
---

K8s的网络介绍

<!-- More -->

### K8s集群IP

Kubernetes集群内部存在三类IP，分别是：

* Node IP：宿主机的IP地址
* Pod IP：使用网络插件创建的IP（如flannel），使跨主机的Pod可以互通
* Cluster IP：虚拟IP，通过iptables规则访问服务