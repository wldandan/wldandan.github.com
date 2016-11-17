---
layout: post
title: "微服务实战(2) - 目标系统"
date: 2016-11-15 14:28
comments: true
keywords: 微服务架构, 微服务架构与实践，微服务架构与实践培训
description: 微服务架构与实践
categories: Microservices
published: true
---

过去的几个月，我作为独立咨询师，为多个传统企业提供了微服务架构的培训、咨询以及交付工作。在这些企业中，大部分的开发者对微服务的理解，以“银弹观念”为主。实际上，传统企业在过去多年的业务积累中，由于组织架构、业务发展和市场竞争等综合因素，技术体系相对封闭，缺乏快速交付的理念。因此，微服务的出现，加之社区的热捧，导致这种现象出现也是比较能理解的。

经过2015年的快速普及，微服务的优势被越来越多的传统组织和企业所认可，但由于架构相关的知识本身比较抽象，虽然各大会议上有很多互联网公司的案例分享，但开发者似乎依然很难全面了解微服务架构。

所以，希望通过本系列的文章，以一个模拟的案例为背景，以持续交付和DevOps为主线，帮助初学者理解微服务架构，并能通过动手实验，了解相关的实践以及方法论。

<!-- More -->

## 目标系统

> 构建一个用户查看活动、报名活动、接收通知的系统

> * 匿名用户可查看活动列表
> * 匿名用户可以查看活动详情
> * 匿名用户可以查看相关活动推荐和评论
> * 用户登陆成功后完成报名
> * 报名成功，用户获取通知
 
## 服务定义

> 关于服务的划分，是一个非常有深度的话题，与业务场景、技术实现、团队能力有着密不可分的关系。
>从方法论上有：

> * 根据[DDD](https://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)，包括业务上下文、事件驱动、读写分离等
> * 根据名词类对象，譬如商品、订单等
> * 根据动词类行为，譬如支付，预订等
> * 其他切入点

> 在这个模拟场景中，为了保持简洁，我假定使用名词和动词进行划分，包括如下：

 * `活动服务Event-service`(提供活动的列表和活动详情的相关数据）
 * `推荐服务Recommendation-service`(提供与某个活动相关的推荐信息)
 * `评论服务Review-service`(提供与某个活动相关的评论信息)
 * `活动聚合服务Event-composite-service`(聚合服务 - 提供某个活动及其相关的推荐、评论信息
 * `报名服务Enroll-service`(为登录用户提供报名)
 * `通知服务Notification-service`(用户报名成功后获取通知)


> 该活动报名系统的应用架构图如下：

<img src="{{ root_url }}/images/microservice-in-action-with-spring/events-system-architecture-600-450.png" />


## 服务实现

* Java 8/Gradle 2.13
* SpringBoot 1.4.2 / SpringCloud Camden.SR2
* MongoDB 使用Document存储活动数据
* REST/HAL/HAL-Browser 定义服务之间通信的接口
* JVM-Pact 实现契约测试,服务间接口的测试

## 服务支撑组件

* Netflix OSS Eureka 实现服务注册
* Spring Cloud Config 实现服务的配置
* Hystrix/Turbine 实现断路器
* Zuul 实现API网关
* Spring Cloud Security 实现安全

## 基础设施

* ELK 提供服务的日志的聚合服务
* Prometheus 提供服务的监控与告警
* Jenkins 2.0搭建系统的持续交付流水线
* Docker提供服务的打包以及发布
* Rancher提供Docker的轻量级管理方案


> 该活动报名系统的微服务生态系统图如下：

<img src="{{ root_url }}/images/microservice-in-action-with-spring/microservices-eco-system-adoption-600-450.png" />

## 总结

  通过理论+模拟+实战的方式，梳理微服务的生态系统，并以持续交付和DevOps的实施为主线，体系化的形成微服务从0到1的学习过程。