---
layout: post
title: "[Serverless 101] - 初识Serverless"
date: 2020-02-15 08:53:17 +0800
comments: true
categories: Serverless
---

2019年3月，伯克利的一篇论文《A Berkeley View on Serveless Computing》，预测了Serverless对未来10年云计算的影响；

2019年12月，AWS REInvent上发布了诸多Serverless相关的更新，反响热烈。

Serverless无疑已经成为学术界和工业界关注的焦点。

本文主要聊聊个人对Serverless的一些理解。

<!--More-->


### 一、什么是Serverless

回顾过去互联网快速发展的数年，催生了诸多技术领域的创新，如大数据、微服务、DevOps等。这些技术并没有个统一的定义，而是依赖于社区的蓬勃发展，不断优化其定义。

类似的，Serverless也没有一个官方的定义，但已经有不少总结帮助我们理解到底什么是Serverless，如下便是个人认为的重要总结：

#### 1.使能开发者，关注业务逻辑本身而非应用的部署、维护和管理

Serverless technology is an infrastructure abstraction which enables developers to **focus on writing software and managing application performance, rather than deploying, maintaining and scaling the underlying server infrastructure**。


 ---《Overview of severless technology, Enterprise Serverless User Cases》

#### 2.无需管理服务器即可运行应用，并能按需的执行、扩缩容和付费

Serverless computing refers to the concept of building and running applications that do not require server management. It describes **a fine-grained deployment meodel where applications, bundled as one or more functions, are uploaded to a platform and then executed, scaled and billed in response to the exact demand needed at the moment**. 

--- 《What is Serveress Computing, CNCF Serverles Whitepaper v1.0》

#### 3.是FaaS + BaaS的共同体

Serverless encompasses **two different areas: FaaS and BaaS.**

FaaS(Function As A Service) - 由开发人员编写函数，事件触发、短生命周期，通常在容器或轻量级VM中运行。
BaaS(Backend As A Service) - 由云厂商提供，支撑函数实现业务逻辑。典型的BaaS包括：

* 数据库系统 (RDS/NoSQL...)
* 存储系统 (S3...)
* 鉴权系统 (Auth0...)
* 集成系统 (API-GW, EventsBridge...)
 

 基于如上的定义，我们对Serverless已经有了大致的理解，核心关键字**无需关注服务器**，**使能业务快速开发**，**由FaaS+BaaS生态**构成。

 **总结如下：Serverless就是使能开发者聚焦业务实现、无需关注运维与基础设施、并能按需使用和付费的技术与模式**

### 二、Serverless的核心

在伯克利的论文中，提出了一大假设：

**Serverless的出现，极大简化了云计算的变成模型，将是软件生产力的一次大变革**。举例来说，（Serverful）向Serverless的演进，就如同若干年前，汇编语言向高级语言的演进。
> 回想汇编语言的时代，开发者不仅需要考虑指令集，还需要熟悉寄存器的读取、信号的中断等。而高级语言的诞生，解放了开发者，不再需要考虑这些底层的细节，更关注业务逻辑。
就好比没有人会用汇编来实现Web应用，而是使用诸如PHP/JSP/NodeJS等技术。

纵观历史，软件开发领域存在的五次大变革，都极大提高了开发者的工作效率：

* 云服务(IaaS)的出现：解决了基础架构的成本和可扩展性问题
* 开源社区：如开源社区、会议、博客、Workshop，使得知识的传播速度加快
* 项目管理工具：版本控制、协作工具、持续集成工具解决了项目的并行开发和集成问题
* 容器：定义了应用打包、部署和发布的标准化机制
* Serverless：使能开发者聚焦业务实现、无需关注运维与基础设施、并能按需使用和付费的技术与模式

这些变革有一个共同点：那就是为软件工程师赋予了更多权利，帮助更快的交付有价值的应用。

围绕Severless带来的变革，我理解主要有两大核心特征：

1. **零运维：开发人员/运维人员不再需要承担构建分布式系统的(大部分)运维成本**。通常，为了构建高可用的分布式系统，我们需要考虑：

* 单点故障：
* 异地容灾：
* 负载均衡
* 自动扩缩容
* 监控告警
* 调用链跟踪
* 补丁与升级

Serverless 不仅帮助开发人员降低资源的维护和管理成本，也能够完成如上所述的自动扩缩容、高可用等机制。使得开发人员可以把精力聚焦在真正的业务上，快速创新

2. **零浪费：按照代码运行所需的资源进行计费，而非分配或者租用的资源**。

以计算资源为例，对于传统公有云基础设施资源而言，计费方式是基于资源的租用时长(如EC2启动后，即便不运行任何业务，也会以分钟为单位进行计费。)

基于Serverless，基础设施是按照运行(代码)时消耗的资源进行收费，如Lambda是按照请求次数及（占用资源的）GB-S为单位进行计费。无请求处理， 则无需支付任何费用。


### 三、什么场景适合使用Serverless

Serverless的应用场景，通常是“事件驱动、短生命周期的无状态”应用。主要包括如下几类：

#### 1.事件驱动的后端服务：

包括Web、移动App、IOT应用的后端服务等，如：

* Web、移动App的后端实现(通过用户的交互触发事件)
* IOT应用的后端实现(通过设备状态的变化触发或者上报事件)
* WebHook的后台处理（通过Hook方式触发的事件）
* ChatBot等聊天机器人
* Alexa等智能音箱的应用

#### 2.数据处理类应用：

包括对数据的渲染、叠加或者处理等应用，如：

* 报表等数据处理（对原始数据进行封装）
* ETL或者数据同步（对数据的抽取、转化和加载）
* 视频或者图像处理 (生成不同分辨率的图像或者视频)

#### 3.适配类应用

* 协议类型的转换(如IOT中不同设备管理，需要协议适配)
* 与第三方平台的接入（如通过第三方提供的接口，接入或者协作的业务）


参考伯克利的论文，目前Serverless主要应用场景如下：


> 可以看出，移动应用/互联网应用作为目前应用形态的主流，在Serverless应用占比中是最高的。个人估计，随着IOT、AI等应用的普适与快速发展，这类应用在采用Serverless的统计中占比会增加。


### 四、Serverless带来的改变

#### 1.开发理念的转变

Serverless的出现，使得开发者更注重逻辑的快速实现，而无需关注运行、维护的成本，也就是**从以资源为中心向以应用为中心**观念的转变。

#### 2.角色职责的转变

Serverless的出现，使得架构师、开发人员和运维人员的职责都发生了变化：

* 架构师：从单体应用的**只关注架构设计**，到微服务时代的**You build it, you own it**(从设计到运行到运维)。Serverless的出现，使得架构师能够更加聚焦业务带来的技术挑战。

* 开发人员：微服务时代，开发者需学习不同框架、语言；Serveless时代， 关注输入/输出，和函数代码的处理逻辑

* 运维人员：关注基础设施、运行时、监控告警、可靠性等问题，大部分可以交给Serverless平台处理了。


### 五、Serverless面临的挑战

Serverless为开发人员带来了诸多便捷，但它依然处理发展的初期，相比与完善的Serverful的生态，还存在很多不足。主要包括：

#### 1.计算领域

* 冷启动
* 异构计算
* 调度优化

#### 2.存储模型

* 如何实现高性能、成本可控且可透明伸缩的存储机制

#### 3.通信模型

Serverless中的Function是不能直接寻址的，所以无法通过现有的数据一致性算法/机制实现数据的共享或者传递。Serverless必然会推动分布式数据协同机制的发展。

#### 4.安全相关

* 物理资源共享引起的攻击
* 细粒度的权限控制
* 数据安全风险

#### 5.生态

* 工具成熟度
* 遗留系统的迁移
* Serverless的设计模式
* 合适的资源抽象
* 端边云的协同

### 参考

* 《A Berkeley View on Serveless Computing》
* 《CNCF Serverless Whitepaper》
* 《Enterprise Serverless user cases》