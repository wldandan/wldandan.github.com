---
layout: post
title: "微服务实战 - 大纲"
date: 2016-11-03 14:28
comments: true
keywords: 微服务架构, 微服务架构与实践，微服务架构与实践培训
description: 微服务架构与实践
categories: Microservices
published: true
---

<script src="https://cdn1.lncld.net/static/js/av-mini-0.6.10.js"></script>
<script src="http://jerry-cdn.b0.upaiyun.com/hit-kounter/hit-kounter-lc-0.2.0.js"></script>


过去的几个月，我作为独立咨询师，为多个传统企业提供了微服务架构的培训、咨询以及交付工作。在这些企业中，大部分的开发者对微服务的理解，以“银弹观念”为主。实际上，传统企业在过去多年的业务积累中，由于组织架构、业务发展和市场竞争等综合因素，技术体系相对封闭，缺乏快速交付的理念。因此，微服务的出现，加之社区的热捧，导致这种现象出现也是比较能理解的。

经过2015年的快速普及，微服务的优势被越来越多的传统组织和企业所认可，但由于架构相关的知识本身比较抽象，虽然各大会议上有很多互联网公司的案例分享，但开发者似乎依然很难全面了解微服务架构。

所以，希望通过本系列的文章，以一个模拟的案例为背景，以持续交付和DevOps为主线，帮助初学者理解微服务架构，并能通过动手实验，了解相关的实践以及方法论。

<!-- More -->

## 本系列的核心思路

 * 以微服务生态系统和持续交付为指导原则
 * 以模拟案例实战为主，并使用SpringBoot/Spring Cloud实现服务
 * 分为`服务构建`与`服务实施`两个专题，包括应用架构，部署模型和交付流水线

 
## 希望能获得的收益：

#### 1.全面了解微服务架构的理论基础

 * 微服务的定义与认识误区
 * 微服务的核心原则以及同SOA的区别联系
 * 微服务的生态系统
 * 微服务的持续交付体系

> 微服务诞生因素

<img src="{{ root_url }}/images/microservice-in-action-with-spring/microservices-factors-800-600.png" />


#### 2.基于微服务生态系统，搭建模拟的微服务案例

* 通过案例理解微服务架构生态系统
* 掌握REST & HAL & HAL Browser的使用方式
* 掌握Spring Boot的核心与使用
* 熟悉Spring Cloud Netflix的服务支撑组件

> 微服务生态系统

<img src="{{ root_url }}/images/microservice-in-action-with-spring/microservices-eco-system-800-600.png" />

#### 3.理解微服务的高级话题

* 使用PACT契约测试验证服务接口
* 使用OAuth与JWT实现服务的安全
* RESTful API设计相关

> 应用架构图

<img src="{{ root_url }}/images/microservice-in-action-with-spring/events-system-architecture-800-600.png" />



#### 4.如何实施微服务与DevOps(基于Docker)

 * 建立Docker私有仓库，并将服务发布成Docker镜像
 * 使用Docker搭建Jenkins持续交付流水线 
 * 以Pipeline as Code的方式管理流水线
 * 使用ELK实现日志聚合的实践
 * 使用Prometheus实现监控告警的实践
 * 使用Rancher完成服务Docker镜像的部署

> 部署模型图

<img src="{{ root_url }}/images/microservice-in-action-with-spring/events-system-deployment-800-600.png" />

> 持续交付流水线

<img src="{{ root_url }}/images/microservice-in-action-with-spring/events-system-cd-800-600.png" />




#### 5.提供完整可运行的源码，降低学习成本😁

## 总结

  通过理论+模拟+实战的方式，梳理微服务的生态系统，并以持续交付和DevOps的实施为主线，体系化的形成微服务从0到1的学习过程。