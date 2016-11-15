---
layout: post
title: "微服务实践 - 使用HAL设计REST API"
date: 2016-10-09 23:45
comments: true
keywords: 微服务架构, 微服务架构与实践，微服务架构与实践培训
description: 微服务架构与实践培训
categories: Microservices
---

REST API通常作为服务间协作的轻量级通信协议(语言无关、平台无关)被广泛采用。

在微服务架构的中，如何有效的设计REST API，如何处理API响应中资源的依赖关系，服务规模化后如何提高服务团队间的协作效率.....这些都成为微服务实践中REST API设计的挑战。

本篇结合我在微服务项目中的实践，谈谈如何使用HAL优雅的设计REST API

<!-- More -->

### REST 101

REST（Representational State Transfer，表述性状态传递）是近几年使用广泛的架构风格之一。在微服务架构的实践中，REST经常作为服务间协作的轻量级通信协议(语言无关、平台无关)被采用。

REST从语义层面将响应结果定义为资源，并使用HTTP协议的标准动词映射为对资源的操作，形成了一种以资源为核心、以HTTP协议为操作方式的，与语言无关、平台无关的服务间的通信机制。

通过资源表述、状态转移以及统一接口，REST将客户端的请求、服务器端的响应基于资源联系起来，形成一种以资源为核心、以HTTP协议为操作方式的，与语言无关、平台无关的通信机制。

同时，由于HTTP协议本身的无状态性，使用REST，能够有效保持服务应用的无状态型，并利于水平伸缩。

### REST不是银弹

随着组织业务的不断增长，服务规模化的实施，以及响应内容复杂度的增加，REST的使用面临如下两个挑战：

* 如何标准化资源结构

使用REST，需要将业务场景的响应抽象为资源，并基于JSON或者XML的格式，返回给客户端。随着业务复杂度的增加，响应的内容会愈发复杂。

REST架构风格，并没有定义响应结构应该遵循什么标准。这也就意味着，在企业内部，不同的部门，不同的开发团队，对同一类资源，所定义的结构可能不尽相同；

譬如，如下是服务器端对客户端获取产品请求的的响应结果，两种结构都是合理的，但存在着差异

	GET http://bookstore.com/books/12 
	Accept: application/json
---

	响应结构一
	{  
		"name":"Spring Boot In Action",  
		"category": "Book",  
		"price":69.00,  
		"ref": "http://bookstore.com/books/12",
		"created_at": "2015-05-01 10:00:00",
		"updated_at": "2015-06-01 11:00:00"
	}  
---
	
	响应结构二
	{
	  "basic_info":
	  {
	   	"name":"Spring Boot In Action",
	   	"category":"Book"
	   	"price":69.00,
	  },

	  "ref":{
	  	"self": "http://bookstore.com/books/12”,
	  	“list": "http://bookstore.com/books"
	  },

	  "timestamp":{
	    "created_at": "2015-05-01 10:00:00",
	    "updated_at": "2015-06-01 11:00:00"
	  }
	}

因此，如何定义一套标准的资源响应结构，成为服务规模化后使用REST面临的一个挑战。


* 如何处理资源的跳转链接

在[《Richardson Maturity Model》](http://martinfowler.com/articles/richardsonMaturityModel.html)模型中，定义了REST API不同成熟度应该具备的特征。

对于REST API Level 3，明确提出了"资源跳转的重要性"。

对于实际情况而言，大部分REST的实现，都是基于JSON作为传输格式，不过JSON最大的遗憾，正如W3C所描述的：

> JSON has no built-in support for hyperlinks, which are a fundamental building block on the Web.

> 没有对超链接处理做内建的支持，是JSON最大的遗憾。而这部分却恰恰是互联网的基石。


这带来的潜在问题是，对于调用接口的Consumer而言，需要通过查看相关文档，才能了解如何获取相关的资源信息。譬如，某些社交系统可能会提供类似如下的接口文档，来帮助Consumer了解如何使用其提供的接口。

	https://api.example.com/users/1234567890      GET 获取用户明细
	https://api.example.com/users/[ID]/friends    GET 获取用户相关的好友
	https://api.example.com/users/[ID]/posts      GET 获取用户相关的文章


### HAL 101 

HAL（Hypertext Application Language）是一种轻量级超文本应用描述协议。HAL的实现基于REST，并对REST中资源结构无法标准化和不支持资源间跳转链接做了有效的互补。

目前，越来越多的企业和组织开始使用HAL提供标准化的服务接口，譬如

* [AWS APP Stream API](http://docs.aws.amazon.com/appstream/latest/developerguide/rest-api-application.html)

* [SMXEmail API](https://smxemail.com)

* [牛津大学官方数据API](http://api.m.ox.ac.uk/browser/#/)

更多案例请可以参考[HAL官方网站](http://stateless.co/hal_specification.html)。

### HAL核心

在HAL中，任何响应都被定义成一种资源（Resource），这是遵循REST原则对资源的定义标准。
同REST不同的是，在每个资源中，HAL又将其分成了如下三个标准的部分：

* 状态(Resource State) - 通常指资源本身固有的属性，如之前提到的book的title、price等
* 链接(Links) - 定义了与当前资源相关的资源链接的集合
* 子资源(Embedded Resource) - 描述在当前资源的内部，其嵌套的资源。

<img src="{{ root_url }}/images/microservice-design-and-practice/rest-api-design/hal-model-400-300.png" />

#### 使用HAL定义单一资源(Resource)

对于单一资源而言，如果没有使用HAL，通常我们会定义成这样：

	GET - /api/users/wldandan
	Content-Type: application/json

	{
	    "id": "wldandan",
	    "name": "Wang Lei",
	    "email": "useremail@email.com",
	    "wechat": "abcdefg"
	}	

如果要访问用户相关的联系人资源，可以查看文档获取其他的API接口，如下所示：
	GET - /api/contacts/wldandan
	Content-Type: application/json
	.......

或者将相关信息放在之前返回的结果里：

	{
	    "id": "wldandan",
	    "name": "Wang Lei",
	    "email": "useremail@email.com",
	    "wechat": "abcdefg",
	    "contacts": [
		    {
		    	"id": "chenyue",
	            "name": "Chen Yue"
	            "link": "/api/users/chenyue"
		    },
		    {
		    	"id": "kouxi",
	            "name": "Kou Xi"
	            "link": "/api/users/chenyue"
		    }
	    ]
	}	


如果基于HAL，则使用_links描述相关链接，同时使用_embedded描述嵌套资源，也就是：

	{
	    "_links": {
	        "self": {
	            "href": "http://example.org/api/users/wldandan"
	        }
	    },
	    "id": "wldandan",
	    email: 'useremail@email.com',
	    "name": "Wang Lei"
	    wechat: 'abcdefg',

	    "_embedded": {
	        "contacts": [
            {
                "_links": {
                    "self": {
                        "href": "http://example.org/api/users/chenyue"
                    }
                },
                "id": "chenyue",
                "name": "Chen Yue"
            },
            {
                "_links": {
                    "self": {
                        "href": "http://example.org/api/users/kouxi"
                    }
                },
                "id": "kouxi",
                "name": "Kou Xi"
            }
        	]
    	}
	}

#### 使用HAL定义集合资源(Collection Resource)

对于集合资源而言，如果没有使用HAL，通常我们会定义成这样：

	GET - /api/users
	Content-Type: application/json

	{
	    total: 10
	    page: 5
	    page_size: 2
	    users: [
	    {
	        id: 'wldandan',
	        name: 'Wang Lei'
        },
        {
        	id: 'chenyue',
        	name: 'Chen Yue'
    	},
	    ]
	}

基于HAL，则使用_links描述相关链接，同时使用_embedded描述嵌套资源，则如下所示：
	{
	    "_links": {
	        "self": {
	            "href": "http://example.org/api/users?page=3"
	        },
	        "first": {
	            "href": "http://example.org/api/users"
	        },
	        "prev": {
	            "href": "http://example.org/api/users?page=2"
	        },
	        "next": {
	            "href": "http://example.org/api/users?page=4"
	        },
	        "last": {
	            "href": "http://example.org/api/users?page=5"
	        }
	    },
	    "page_size": 2,
	    "total": 10,
	    "page": 5,
	    "_embedded": {
	        "users": [
	            {
	                "_links": {
	                    "self": {
	                        "href": "http://example.org/api/users/wldandan"
	                    }
	                },
	                "id": "wldandan",
	                "name": "Wang Lei"
	            },
	            {
	                "_links": {
	                    "self": {
	                        "href": "http://example.org/api/user/chenyue"
	                    }
	                },
	                "id": "chenyue",
	                "name": "Chen Yue"
	            }
	        ]
	    }
	}


### 在微服务实现中使用HAL
#### 使用Spring-Data-Rest实现HAL
#### 在Spring Boot中定制HAL
### HAL与HATEOAS


### 参考资料
[Hypertext Application Language](https://apigility.org/documentation/api-primer/halprimer)
[JSON Linking with HAL](http://blog.stateless.co/post/13296666138/json-linking-with-hal)
[Creating Service Contract with AutoRest, Swagger and HAL](Creating Service Contract with AutoRest, Swagger and HAL)
[Implementing HAL hypermedia REST API using Spring HATEOAS](https://opencredo.com/hal-hypermedia-api-spring-hateoas/)
[HAL Specification](http://stateless.co/hal_specification.html)
[hal-discuss@google groups](https://groups.google.com/forum/#!forum/hal-discuss)
[HAL+JSON](http://hyperschema.org/mediatypes/hal)
[Documenting REST APIs – a tooling review](https://opencredo.com/rest-api-tooling-review/)
[HAL Primer](http://phlyrestfully.readthedocs.io/en/latest/halprimer.html)