---
layout: post
title: "微服务实战(4) - Spring Cloud 101"
date: 2016-11-15 23:37
comments: true
keywords: 微服务架构, 微服务架构与实践，微服务架构与实践培训
description: 微服务架构与实践
categories: Microservices
published: false
---

过去的几个月，我作为独立咨询师，为多个传统企业提供了微服务架构的培训、咨询以及交付工作。在这些企业中，大部分的开发者对微服务的理解，以“银弹观念”为主。实际上，传统企业在过去多年的业务积累中，由于组织架构、业务发展和市场竞争等综合因素，技术体系相对封闭，缺乏快速交付的理念。因此，微服务的出现，加之社区的热捧，导致这种现象出现也是比较能理解的。

经过2015年的快速普及，微服务的优势被越来越多的传统组织和企业所认可，但由于架构相关的知识本身比较抽象，虽然各大会议上有很多互联网公司的案例分享，但开发者似乎依然很难全面了解微服务架构。

所以，希望通过本系列的文章，以一个模拟的案例为背景，以持续交付和DevOps为主线，帮助初学者理解微服务架构，并能通过动手实验，了解相关的实践以及方法论。

<!-- More -->

## 服务实施的挑战


### 个体服务的实现越来越容易

在上一节中，我们学习了Spring Boot的核心，明白了```Starter```与```AutoConfiguration```的重要性，并知道了如何快速创建Spring Boot应用。

基于现有的```Spring Framework```，以及```Spring Boot的Starter```，加上```官方CLI```、 ```Initializr```以及各种```IDE```提供的快速创建SpringBoot 应用的方式，我们能轻松的完成一个基于RESTful API的服务实现。

因此，从Spring Boot的优势来看，构建单个的服务单元非常容易了~

> 从IT社区的发展来看，工具正在变得越来越强大，开发人员的大部分重复性工作都将会被简化。

> 伴随着人工智能的快速发展，将来编码的工作都可以交给机器了，喝着咖啡告诉它，你想要什么语言，你的验收条件，啦啦啦....


### 服务间的协作、管理成本越来越高

但是，对于微服务的实施而言，服务单元不会孤立存在，必然相互协作，共同实现业务价值。

<img src="{{ root_url }}/images/microservice-in-action-with-spring/spring-boot/microservice-coordination-600-450.png" />


而随着服务规模化的推进，服务间协作和管理的成本会越来越高，包括但不限于：

* 服务地址发生变化
	* 服务结点数量动态变化(水平伸缩)
	* 服务结点地址动态变化(重启、升级)
* 服务的配置信息变更	
	* 配置信息修改后，如何动态更新单实例
	* 配置信息修改后，如何同步多个实例
	* 配置信息的追溯、回滚及可用性保障
* 服务间调用出现异常	
	* 如何防止调用间的”雪崩”
* 为消费者提供统一接口
	* 如何提供单一的入口简化设备的调用
	* 屏蔽不同的应用协议(MQ/JMS)	

所以，如何应对如上这些问题，成为微服务实施中重要的环节。


## 什么是Spring Cloud

```Spring Cloud```是Pivotal官方提供的旨在帮助开发者降低构建复杂分布式系统的工具集。

2015年3月4日，Spring Cloud发布了第一个GA版本。

Spring Cloud的核心宗旨是：

> A toolset designed for building complexed distributed systems.

在Spring Cloud中，整合了很多功能组件，包括Config、Messaging、Netflix OSS以及对Heroku、Amazon Web Service、Cloud Foundry等云平台的接口支持。

<img src="{{ root_url }}/images/microservice-in-action-with-spring/spring-boot/spring-cloud-components-600-450.png" />

基于这些组件，能够帮助我们解决之前提到的服务实施后面临的挑战。

## 常用的Spring Cloud组件

Spring Cloud中的组件很多，而且在快速的演进中，在本系列```服务构建篇```里，主要涉及的有

> Spring Cloud Netflix

集成了Netflix OSS的组件(Eureka/Ribbon/Hystrix/Zuul等)

> Spring Cloud Config

提供集中化的服务配置信息，动态更新实例的配置

> Spring Cloud Bus

使用分布式消息机制，提供不同服务实例之间的协作

> Spring Cloud Security

提供服务安全相关的实现机制(OAuth2)   


## 总结

> Spring Cloud本着```全家桶```的一站式解决方案，为微服务的实施提供了支持。

> 虽然Spring Cloud GA的时间并不长，但其快速的演进以及Spring大量用户的支持，有可能成为Java领域微服务架构实施的利器，帮助我们有效的应对服务落地时的挑战。