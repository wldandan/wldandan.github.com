---
layout: post
title: "基于微服务架构，改造企业核心系统之实践"
date: 2014-09-16 21:57
comments: true
categories: MicroService
---

本文已经发表于InfoQ，请参考[这里](http://www.infoq.com/cn/articles/enterprise-core-systems-transformation-practice)


##背景与挑战


随着公司国际化战略的推行以及本土业务的高速发展，后台支撑系统已经不堪重负。

在吞吐量、稳定性以及可扩展性上都无法满足日益增长的业务需求。对于每10万元额度的合同，从销售团队准备材料、与客户签单、递交给合同部门，再到合同生效大概需要3.5人天。随着业务量的快速增长，签订合同的成本急剧增加。

合同管理系统是后台支撑系统中重要的一部分。当前的合同系统是5年前使用.NET，基于[SAGE CRM](http://www.sagecrm.com/)二次开发的产品。
一方面，系统架构过于陈旧，性能、可靠性无法满足现有的需求。另一方面，功能繁杂，结构混乱，定制的代码与SAGE CRM系统耦合度极高。

由于是遗留系统，熟悉该代码的人早已离职多时，新团队对其望而却步，只能做些周边的修补工作。同时，还要承担着边补测试，边整理逻辑的工作。

在无法中断业务处理的情况下，为了解决当前面临的问题，团队制定了如下的策略：

<img src="http://wldandan.github.com/images/microservice/crm-rebuild-strategy-600x400.png" />

1. 在现有合同管理系统的外围，构建功能服务接口，将系统核心的功能分离出来。
2. 利用这些功能服务接口作为代理，解耦原合同系统与其调用者之间的依赖；
3. 通过不断构建功能服务接口，逐渐将原有系统分解成多个独立的服务。
4. 摒弃原有的合同管理系统，使用全新构建的(微)服务接口替代。

<!--more-->
##什么是微服务
多年来，我们一直在技术的浪潮中不断乘风破浪，扬帆奋进，寻找更好的方式构建IT系统。

微服务架构(Micro Service Architect)，是近一段时间在软件体架构领域里出现的一个新名词。它通过将功能分解到多个独立的服务中以实现对解决方案或者复杂系统的解耦。

微服务的诞生并非偶然：[领域驱动设计](http://dddcommunity.org/)指导我们如何分析并模型化复杂的业务；[敏捷方法论](http://agilemethodology.org/)帮助我们消除浪费，快速反馈；[持续交付](http://agilemethodology.org/)促使我们构建更快、更可靠、更频繁的软件部署和交付能力；虚拟化和基础设施自动化(Infrasture As Code)则帮助我们简化环境的创建、安装；[DevOps](http://dev2ops.org/2010/02/what-is-devops/)文化的流行以及特性团队的出现，使得小团队更加全功能化。这些都是推动微服务诞生的重要因素。

实际上，微服务本身并没有一个严格的定义。不过从业界的讨论来看，微服务通常有如下几个特征:

### 小，且专注于做一件事情
每个服务都是个很小的应用，至于有多小，是一个非常有趣的话题。有人喜欢100行以内，有人赞成1000行以内。数字并不是最重要的，仁者见仁，智者见智，只要团队觉得合适就好。

只关注一个业务功能。这一点和我们平常谈论的面向对象原则中的"单一原则"类似，每个服务只做一件事情，并且把它做好。

### 运行在独立的进程中
每个服务都运行在一个独立的操作系统进程，这意味着不同的服务能被部署到不同的主机上。

### 轻量级的通信机制
服务和服务之间通过轻量级的机制实现彼此间的通信。所谓轻量级通信机制，通常指基于语言无关、平台无关的这类协议，例如XML、JSON，而不是传统我们熟知的Java RMI或者.Net Remoting等。

### 松耦合
不需要改变依赖，只更改当前服务本身，就可以独立部署。这意味着该服务和其他者服务之间在部署和运行上呈现相互独立的状态。

综上所述，微服务架构采用多个服务间互相协作的方式构建传统应用。每个服务独立运行在不同的进程中，服务之与服务之间通过轻量的通讯机制交互，并且每个服务可以通过自动化部署方式独立部署。

##微服务的优势

相比传统的单块架构系统(monolithic)，微服务在如下诸多方面有着显著的优势：

#### 异构性

问题有其具体性，解决方案也应有其针对性。用最适合的技术方案去解决具体的问题，往往会事半功倍。传统的单块架构系统倾向采用统一的技术平台或方案来解决所有问题。而微服务的异构性，可以针对不同的业务特征选择不同的技术方案，有针对性的解决具体的业务问题。

对于单块架构的系统，初始的技术选型严重限制将来采用不同语言或框架的能力。如果想尝试新的编程语言或者框架，没有完备的功能测试集，很难平滑的完成替换，而且系统规模越大，风险越高。基于微服务架构，使我们更容易地在遗留系统上尝试新的技术或解决方案。譬如说，
可以先挑选风险最小的服务作为尝试，快速得到反馈后再决定是否试用于其他服务。这也意味着，即便对一项新技术的尝试失败的话，尽可以抛弃这个方案，并不会对整个产品带来风险。



<img src="http://wldandan.github.com/images/microservice/micro-service-advantages-600x400.png" />

上图引用自Martin Fowler的[Microservices](http://martinfowler.com/articles/microservices.html)一文。

#### 独立测试与部署
单块架构系统运行在一个进程中，因此系统中任何程序的改变，都需要对整个系统重新测试并部署。
而对微服务架构而言，不同服务之间的打包、测试或者部署等，与其它服务都是完全独立的。对某个服务所做的改动，只需要关注该服务本身。从这个角度来说，使用微服务后，代码修改、测试、打包以及部署的成本和风险都比单块架构系统降低很多。

#### 按需伸缩
单块架构系统由于单进程的局限性，水平扩展时只能基于整个系统进行扩展，无法针对某一个功能模块按需扩展。
而服务架构则可以完美的解决伸缩性的扩展问题。系统可以根据需要，实施细粒度的自由扩展。

#### 错误隔离性
微服务架构同时也能提升故障的隔离性。例如，如果某个服务的内存泄露，则只会影响到自己，其他服务能够继续正常地工作。与之形成对比的是，单块架构中如果有一个不合格的组件发生异常，有可能会拖垮整个系统。

#### 团队全功能化

康威定律（Conway's law）指出：

```organizations which design systems are constrained to produce designs which are copies of the communication structures of these organizations.```

```一个组织的设计成果，其结构往往对应于这个组织中的沟通结构。```

传统的开发模式在分工时往往以技术为单位，比如UI团队、服务端团队和数据库团队，这样的分工可能会导致任何功能上的改变都需要跨团队沟通和协调。而微服务则倡导围绕服务来分工，团队需要具备服务设计、开发、测试到部署所需的所有技能。

##微服务快速开发实践

随着团队对业务的理解加深和对微服务实践的尝试，数个微服务程序已经成功构建出来。不过，问题同时也出现了：对于这些不同的微服务程序而言，虽然具体实现的代码细节不同，但其结构、开发方式、持续集成环境、测试策略、部署机制以及监控和告警等，都有着类似的实现方式。那么如何满足[DRY原则](http://programmer.97things.oreilly.com/wiki/index.php/Don't_Repeat_Yourself)并消除浪费呢？

带着这个问题，经过团队的努力，Stencil诞生了。
Stencil是一个帮助快速构建Ruby微服务应用的开发框架，主要包括四部分：Stencil模板、代码生成工具，持续集成模板以及一键部署工具。

<img src="http://wldandan.github.com/images/microservice/stencil-template-structure-details-600x400.png" />

###Stencil模板

Stencil模板是一个独立的Ruby代码工程库，主要包括代码模板以及一组配置文件模板。

代码模板使用[Webmachine](https://github.com/basho/webmachine)作为Web框架，[RESTful](http://en.wikipedia.org/wiki/Representational_state_transfer)和JSON构建服务之间的通信方式，RSpec作为测试框架。同时，代码模板还定义了一组Rake任务，譬如运行测试，查看测试报告，将当前的微服务生成RPM包，使用Koji给RPM包打标签等。

除此之外，该模板也提供了一组通用的URL，帮助使用者查看微服务的当前版本、配置信息以及检测该微服务程序是否健康运行等。

	[
		{
			rel: "index",
			path: "/diagnostic/"
		},
		{
			rel: "version",
			path: "/diagnostic/version"
		},
		{
			rel: "config",
			path: "/diagnostic/config"
		},
		{
			rel: "hostname",
			path: "/diagnostic/hostname"
		},
		{
			rel: "heartbeat",
			path: "/diagnostic/status/heartbeat"
		},
		{
			rel: "nagios",
			path: "/diagnostic/status/nagios"
		}
	]


配置文件模板主要包括[NewRelic](http://newrelic.com/)配置，[Passenger](https://www.phusionpassenger.com/)配置、[Nagios](http://www.nagios.org/)配置、[Apache](http://httpd.apache.org/)配置以及[Splunk](http://www.splunk.com/)配置。通过定义这些配置文件模板，当把新的微服务程序部署到验收环境或者产品环境时，我们立刻就可以使用Nagios、NewRelic以及Splunk等第三方服务提供的功能，帮助我们有效的监控微服务，并在超过初始阈值时获得告警。

###代码生成工具
借助Stencil代码生成工具，我们能在很短的时间内就构建出一个可以立即运行的微服务应用程序。随着系统越来越复杂，微服务程序的不断增多，Stencil模板和代码生成工具帮助我们大大简化了创建微服务的流程，让开发人员更关注如何实现业务逻辑并快速验证。


	Create a project from the stencil template (version 0.1.27)
	        --name, -n <s>:   New project name. eg. things-and-stuff
	   --git-owner, -g <s>:   Git owner (default: which team or owner)
	        --database, -d:   Include database connection code
	  --triggered-task, -t:   Include triggered task code
	        --provider, -p:   Is it a service provider? (other services use this service)
	        --consumer, -c:   Is it a service consumer? (it uses other services)
	      --branch, -b <s>:   Specify a particular branch of Stencil
	       --face-palm, -f:   Overide name validation 
	            --help, -h:   Show this message

如上图所示，通过指定不同参数，我们能创建具有数据库访问能力的微服务程序、或者是包含异步队列处理的微服务程序。同时，我们也可以标记该服务是数据消费者还是数据生产者，能帮助我们理解多个微服务之间的联系。

###持续集成模板
基于持续集成服务器[Bamboo](https://www.atlassian.com/software/bamboo)，团队创建了针对Stencil的持续集成模板工程，并定义了三个主要阶段：

* 打包：运行单元测试，集成测试，等待测试通过后生成RPM包。
* 发布：将RPM包发布到[Koji](http://koji.fedoraproject.org/koji/)服务器上，并打上相应的Tag。然后使用[Packer](http://www.packer.io/)在亚马逊AWS云环境中创建AMI，建好的AMI上已经安装了当前微服务程序的最新RPM包。
* 部署：基于指定版本的AMI，将应用快速部署到验收环境或者产品环境上。

利用持续集成模板工程，团队仅需花费很少的时间，就可以针对新建的微应用程序，在Bamboo上快速定义其对应的持续集成环境。

###一键部署工具
所有的微服务程序都部署并运行在亚马逊AWS云环境上。同时，我们使用[Asgard](https://github.com/Netflix/asgard)对AWS云环境中的资源进行创建、部署和管理。
Asgard是一套功能强大的基于Web的AWS云部署和管理工具，由Netflix采用[Groovy on Grails](http://grails.org/)开发，其主要优点有：
	- 基于B/S的AWS部署及管理工具，使用户能通过浏览器直接访问AWS云资源，无需设置Secret Key和Access Key；
	- 定义了`Application`以及`Cluster`等逻辑概念，更清晰、有效地描述了应用程序在AWS云环境中对应的部署拓扑结构。
	- 在对应用的部署操作中，集成了AWS Elastic Load Balancer、AWS EC2以及AWS Autoscaling Group，并将这些资源自动关联起来。
	- 提供RESTful接口，能够方便的与其他系统集成。
	- 简洁易用的用户接口，提供可视化的方式完成一键部署以及流量切换。


由于Asgard对RESTful的良好支持，团队实现了一套基于Asgard的命令行部署工具，只需如下一条命令，提供应用程序的名称以及版本号，就可自动完成资源的创建、部署、流量切换、删除旧的应用等操作。

	asgard-deploy [AppName] [AppVersion]

同时，基于命令行的部署工具，也可以很容易的将自动化部署集成到Bamboo持续集成环境。


通过使用微服务框架Stencil，大大缩短了团队开发微服务的周期。同时，基于Stencil，我们定义了一套团队内部的开发流程，帮助团队的每一位成员理解并快速构建微服务。


##微服务架构下的新系统

经过5个月的努力，我们重新构建了合同管理系统，将之前的产品、价格、销售人员、合同签署、合同审查以及PDF生成都定义成了独立的服务接口。相比之前大而全、难以维护的合同管理系统而言，新的系统由不同功能的微服务组成，每个微服务程序只关注单一的功能。每个微服务应用都有相关的负责人，通过使用[Page Duty](http://www.pagerduty.com/)建立消息通知机制。每当有监控出现告警的时候，责任人能立即收到消息并快速做出响应。

<img src="http://wldandan.github.com/images/microservice/micro-service-app-600x400.png" />


由于微服务具有高内聚，低耦合的特点，每个应用都是一个独立的个体，当出现问题时，很容易定位问题并解决问题，大大缩短了修复缺陷的周期。
另外，通过使用不同功能的微服务接口提供数据，用户接口(UI)部分变成了一个非常简洁、轻量级的应用，更关注如何渲染页面以及表单提交等交互功能。

###总结
通过使用微服务架构，在不影响现有业务运转的情况下，我们有效的将遗留的大系统逐渐分解成不同功能的微服务接口。

同时，通过Stencil微服务开发框架，我们能够快速的构建不同功能的微服务接口，并能方便的将其部署到验收环境或者产品环境。


最后，得益于微服务架构的灵活性以及扩展性，使得我们能够快速构建低耦合、易扩展、易伸缩性的应用系统。



###参考文献
http://martinfowler.com/articles/microservices.html   
http://jaxenter.com/cracking-microservices-practices-50692.html  
http://microservices.io/patterns/microservices.html


