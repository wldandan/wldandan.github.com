---
layout: post
title: "k8s之Deployment"
date: 2019-04-06 14:48
comments: true
keywords: K8s
description: K8s
categories: K8s
published: true
---

之前我们了解了如何打包，作为Pod中的容器运行，使用临时或者永久存储机制，设置配置项，接下来我们探讨如何部署和升级。

##### 应用更新的方式

假定在K8S中存在这样的应用：
* Service
* 3个Pod
* 使用ReplicaSet
* Clients

初始情况，运行V1版本的应用。接下来，我们希望生成V2版本的镜像，并使用V2版本的Pod/容器进行升级。
存在两种方式：
* 先删除V1版本的应用，然后部署V2版本。
* 先新增V2版本的应用，然后删除V1版本。（对于V2版本的新增，可以选择 ```一次新增全部数量```，```多次新增，每次部分数量```）

> 对于第一种方式：简单，但是存在部署的停机时间  
  对于第二种方式：系统需要同时处理两个版本的应用，尤其是数据Schema需要兼容新旧两个版本

###### ttt
