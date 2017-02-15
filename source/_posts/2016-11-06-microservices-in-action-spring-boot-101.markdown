---
layout: post
title: "微服务实战(3) - Spring Boot 101"
date: 2016-11-06 17:57
comments: true
keywords: 微服务架构, 微服务架构与实践，微服务架构与实践培训
description: 微服务架构与实践
categories: Microservices
published: true
---

[如需转载，请联系本人]

过去的几个月，我作为独立咨询师，为多个传统企业提供了微服务架构的培训、咨询以及交付工作。实际上，传统企业在过去多年的业务积累中，由于组织架构、业务发展和市场竞争等综合因素，技术体系相对封闭，缺乏快速交付的理念。因此，微服务的出现，加之社区的热捧，导致很多传统的团队过于追热而并没有完全理解微服务。

经过2015年的快速普及，微服务的优势被越来越多的传统组织和企业所认可，但由于架构相关的知识本身比较抽象，虽然各大会议上有很多互联网公司的案例分享，但开发者似乎依然很难全面了解微服务架构。

所以，希望通过本系列的文章以及视频，以一个真实的案例为背景，以持续交付和DevOps为主线，帮助初学者理解微服务架构，并能通过动手实验，了解相关的实践以及方法论。

精彩课程已经出炉，请移步[这里](http://www.stuq.org/course/detail/1088)

<!-- More -->

## 为什么是Spring Boot

在Java开发领域，估计没有多少兄弟不知道Spring，当年的SSH组合，风靡社区，几乎成为J2EE 程序开发的标配。

另外，Spring对诸多企业特性的强大支持，为构建Java的企业应用提供了`全家桶`的解决方案。

<img src="{{ root_url }}/images/microservice-in-action-with-spring/spring-boot/spring-io-600-450.png" />

对于现代Java开发，尤其是以微服务为主的应用，虽然有[DropWizard](https://dropwizard.github.io/)、[KumuluzEE](https://ee.kumuluz.com/)等微服务框架的诞生，但Spring Boot借助极致的`Convention Over Configuration`，加上对`Spring Framework`的无缝支持，被社区普遍看好。

在今年10月中旬结束的[2016 JAX Java Innovation](https://jaxlondon.com/jax-awards/)评选中，Spring Boot一举拔得头筹，而去年Java领域的这个奖项是颁给了著名的[Netflix OSS](https://netflix.github.io/)，足以证明Spring Boot在社区的影响力。

<img src="{{ root_url }}/images/microservice-in-action-with-spring/spring-boot/jax-award-spring-boot-600-450.png" />

 
## Spring Boot的优势

* `快速构建`可运行的应用
	* `无XML配置`
	* 支持`内嵌`WebServer(Tomcat/Jetty/Undertow)
	* 通过`注解`的方式，一行代码启动应用
* `自动配置`和`装载机制`
	* 使用Starter
	* 自动配置装载依赖
* 运维接口友好
	* `Metrics/health`显示健康监控状态
	* `Trace/dump`显示调用/调试信息


## Spring Boot核心

### 简单的说，Spring Boot的核心，主要包括两大部分：

> 1.Starter

Starter负责将申明的依赖Jar包导入到当前ClassPath。

每个Starter都提供一个```spring.providers文件```，申明当前Starter依赖的Jar包。


譬如，```Spring-boot-starter-web```中的```spring.providers文件```描述的依赖如下所示：

```
provides: spring-webmvc,spring-web,jackson-databind
```

包括```spring-webmvc```，```spring-web```，```jackson-databind```，分别提供mvc，web和JSON解析绑定的功能。


欲了解更多的Starter，请移步[官方列表](https://github.com/spring-projects/spring-boot/tree/master/spring-boot-starters)

> 2.AutoConfiguratioin

AutoConfiguratioin根据```ConditionalOnXxx```条件，使用```@Bean```注解，完成对Bean的创建和组装。

根据不同的```ConditionalOnXxx```，AutoConfiguration可以根据合适的场景创建并组装Bean。

譬如
```
ConditionalOnMissingBean(A.class)
```

> 表示当前指定的A实例不存在，才创建@Bean.

```
ConditionalOnWebApplication
```

> 表示当前是在Web Application才创建@Bean

Java Web中我们经常使用```HttpEncodingAutoConfiguration```，完成UTF8的转码。如下是SpringBoot中，HttpEncodingAutoConfiguration的部分实现：

> 仅当ApplicationContext中没有CharacterEncodingFilter的时候，才会创建```CharacterEncodingFilter```

```
	@Bean
	@ConditionalOnMissingBean(CharacterEncodingFilter.class)
	public CharacterEncodingFilter characterEncodingFilter() {
		CharacterEncodingFilter filter = new OrderedCharacterEncodingFilter();
		filter.setEncoding(this.properties.getCharset().name());
		filter.setForceRequestEncoding(this.properties.shouldForce(Type.REQUEST));
		filter.setForceResponseEncoding(this.properties.shouldForce(Type.RESPONSE));
		return filter;
	}
```

> 所以, 我对SpringBoot的理解为，如下两个核心点(配合起来，天下无敌....)

* ```Starter打包提供相关的包依赖，加载到ClassPath```
* ```EnableAutoConfiguration借助ConditionalOnXxx条件，创建并配置Bean的依赖关系```



关于更多```Conditional```的细节，请查看包
*org.springframework.boot.autoconfigure.condition*中的具体实现，其列表如下图所示：

<img src="{{ root_url }}/images/microservice-in-action-with-spring/spring-boot/spring-boot-conditional-xxx-600-450.png" />


### 另外，每个SpringBoot应用上都会加标签@SpringBootApplication

这个标签是SpringBoot应用的核心标签，主要包括三部分子：

* @Configuration

Spring3.0引入@Configuration(Java配置)，使用Java配置简化XML配置。

譬如以前我们通常使用类似如下XML配置Spring Bean

```
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

	<bean id="helloBean" class=“com.microservice.training.HelloWorldImpl">
</beans>
```

通过使用Java Configuration，声明当前类是一个配置类， 相当于声明一个Spring配置的XML文件

```
@Configuration
public class AppConfig {

    @Bean(name="helloBean")
    public HelloWorld helloWorld() {
        return new HelloWorldImpl();
    }
}
```


* @EnableAutoConfiguration

它帮助我们加载当前Spring Boot中META-INF/spring.factories，并使用其中的*AutoConfiguration

```
HttpEncodingAutoConfiguration
RabbitAutoConfiguration 
EmbeddedServletContainerAutoConfiguration
……
```

每个AutoConfiguration都会根据其中的Condition条件，在合适的场景完成对相关Bean的创建

```
@ConditionalOnBean //容器里有指定Bean存在
@ConditionalOnClass //类路径下有指定Class存在
@ConditionalOnWebApplication //当前项目是Web项目
……
```

* @ComponentScan

它定义Spring了自动加载Bean的根路径，是Spring Framwork中较早的一个标签，这里就不赘述了。


## 快速构建Spring Boot应用

Spring Boot提供了方便的项目创建方式，使得我们可以快速创建基于SpringBoot的项目：

* 使用[命令行CLI](http://sdkman.io/)
* 使用[Initializr](start.spring.io)
* 使用IDE(IDEA，Spring Tool Suite等)


## 总结

> 本部分介绍了SpringBoot的核心，并提到了快速创建SpringBoot应用的方式，通过这部分内容，能够帮助大家完成```SpringBoot从0到1的过程``` :)

> 关于课程，请看[这里](http://www.stuq.org/course/detail/1088)