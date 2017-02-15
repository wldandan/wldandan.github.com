---
layout: post
title: "微服务实战(1) - 内容大纲"
date: 2016-11-04 14:28
comments: true
keywords: 微服务架构, 微服务架构与实践，微服务架构与实践培训
description: 微服务架构与实践
categories: Microservices
published: true
---

<script src="https://cdn1.lncld.net/static/js/av-mini-0.6.10.js"></script>
<script src="http://jerry-cdn.b0.upaiyun.com/hit-kounter/hit-kounter-lc-0.2.0.js"></script>

[如需转载，请联系本人]

过去的几个月，我作为独立咨询师，为多个传统企业提供了微服务架构的培训、咨询以及交付工作。实际上，传统企业在过去多年的业务积累中，由于组织架构、业务发展和市场竞争等综合因素，技术体系相对封闭，缺乏快速交付的理念。因此，微服务的出现，加之社区的热捧，导致很多传统的团队过于追热而并没有完全理解微服务。

经过2015年的快速普及，微服务的优势被越来越多的传统组织和企业所认可，但由于架构相关的知识本身比较抽象，虽然各大会议上有很多互联网公司的案例分享，但开发者似乎依然很难全面了解微服务架构。

所以，希望通过本系列的文章以及视频，以一个真实的案例为背景，以持续交付和DevOps为主线，帮助初学者理解微服务架构，并能通过动手实验，了解相关的实践以及方法论。

精彩视频课程已经出炉，请移步[这里](http://www.stuq.org/course/detail/1088)

<!-- More -->

## 核心思路

 * 以`微服务生态系统`和`持续交付`为指导原则
 * 以`模拟案例实战`为主，并使`用SpringBoot`和`Spring Cloud`实现服务
 * 分为`服务构建`与`服务实施`两个专题，包括`应用架构`，`部署模型`和`交付流水线`

 
## 主要亮点

#### 1.全面了解微服务架构的理论基础

 * 微服务的定义与认识误区
 * 微服务的核心原则以及同SOA的关系
 * 微服务的`持续交付体系`


#### 2.基于微服务生态系统，搭建模拟案例

* 通过案例理解`微服务架构生态系统`
* 掌握`REST & HAL & HAL Browser`的使用方式
* 掌握`Spring Boot`的核心与使用
* 熟悉`Spring Cloud`的服务支撑组件

> 微服务生态系统

<img src="{{ root_url }}/images/microservice-in-action-with-spring/microservices-eco-system-600-450.png" />

#### 3.理解微服务的高级话题

* 使用`PACT契约测试`验证服务接口
* 使用`OAuth`与`JWT`实现服务的安全
* `RESTful API`设计相关

> 基于消费者驱动的契约测试

<img src="{{ root_url }}/images/microservice-in-action-with-spring/pact-600-450.png" />


#### 4.理解实施微服务与DevOps(基于Docker)

 * 建立`Docker私有仓库`，并将服务发布成Docker镜像
 * 使用`Docker搭建Jenkins`持续交付流水线 
 * 以`Pipeline as Code`的方式管理流水线
 * 使用`ELK实现日志聚合`的实践
 * 使用`Prometheus`实现监控告警的实践
 * 使用`Rancher`完成服务Docker镜像的部署

> 部署模型图

<img src="{{ root_url }}/images/microservice-in-action-with-spring/events-system-deployment-600-450.png" />

> 持续交付流水线

<img src="{{ root_url }}/images/microservice-in-action-with-spring/events-system-cd-600-450.png" />


## 总结

> 通过理论+模拟+实战的方式，梳理微服务的生态系统，并以持续交付和DevOps的实施为主线，体
> 系化的形成微服务从0到1的学习过程。

> 关于课程，请看[这里](http://www.stuq.org/course/detail/1088)
