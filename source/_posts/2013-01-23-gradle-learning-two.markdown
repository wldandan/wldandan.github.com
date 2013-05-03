---
layout: post
title: "Gradle Learning - 2 (project&task)"
date: 2013-01-23 17:14
comments: true
categories: [Gradle] 
---

上一篇文章中，我们提到了Gradle的一些基本概念，如Project、Task以及Action，并且创建了我们的第一个Task。这次我们来看看Gradle中关于Project和Task的更多细节。

###1. Project和Task

对于build.gradle配置文件，当运行Gradle <Task> 时，Gradle会为我们创建一个Project的对象，来映射build.gradle中的内容。其中呢，对于不属于任何Task范畴的代码，Gradle会创建一个Script类的对象，来执行这些代码；对于Task的定义，Gradle会创建Task对象，并将它会作为project的属性存在(实际上是通过getTaskName完成的)。ok，看一个简单的例子：

新建文件basic/build.gradle,然后加入如下部分代码：

	println "the project name is $name"
	task hello << {
    	println "the current task name is $name"
    	println "hello world"
	}

<!--more-->    
当运行这个例子时，首先Gradle会创建一个Porject的对象，然后将它和build.gradle的内容映射起来。在这个例子中，project包括两部分：
#####1)可执行脚本定义

   按照之前提到的，可执行脚本的定义将直接被创建成对应的Script类的对象
   在这个例子中，Script对应的部分就是第一行println的部分，然后执行的结果就是打印出 "the project name is basic"。
   默认的，Project的名字是当前build.gradle所在目录的名字，在这个例子中，build.gradle放在basic目录下，因此，project的name也就是basic.

#####2)Task定义

  在这个例子中，Gradle将创建一个Task的实例，将其和定义的task内容关联起来。另外，按照之前所说的，当Gradle运行时，我们可以使用访问project属性的方式去访问它。

例如，这个例子中，我们可以使用project.hello来访问这个task。因为这个task hello已经成为project的一个属性，那么当我们使用gradle properties（properties是gradle自带的一个Task,它能列出当前project级别的所有属性，可以使用gradle tasks查看更多内建的Task）来获取project级别的属性列表时，也将会得到'hello'。

另外，有一点要注意的是，在这个例子中，task中使用的$name，并不是Project的name，它是当前Task的name，因为它被使用在Task的scope里。

执行Gradle hello，输出的结果将是：

	current project name is test
	the current task name is hello
	hello world

###2. 定义属性

在Gradle中，我们可以定义以下三种属性并使用它们：

#####1)System Properties

System Properties 实际是指的JVM的system properties。我们知道，在运行java程序时，可以使用-D来设置Java的系统变量，在Gradle中，你也可以做同样的事情。比如

	gradle xxx -DmySystemProp=xxxx

同时，在build.gradle中，应该这样使用这个变量：

	task printSysProps << {
	  println System.properties['system']
	}
#####2)Project Properties 

Project Properties是Gradle专门为Project定义的属性。它的最大优点在于当运行gradle的时候，我们可以使用-P来设置它的值。比如，

	gradle xxx -PmyProjectProp=xxxxx

而在build.gradle中，可以这样使用这个变量： 

	task printProps << {
	    if (project.hasProperty('commandLineProjectProp')) {  
	        println commandLineProjectProp
	    }  
	}
同时，当我们执行gradle properties查看属性列表时，这个变量的名称以及值会显示在结果中。
#####3)Ext(ra) Properties

    另外，我们还可以为Project或者Task定义Ext属性，也称动态属性，我们必须使用关键字ext(对应ExtraPropertiesExtension的实例)去定义动态属性。从这点可以看出，Gradle已经为我们设计了很多不同的类，去做不同的事情，我们只需要遵循Convention，使用他们即可。如果忘记写ext关键字，gradle运行时则会提示:

"Dynamic properties are deprecated...."。这是因为以前版本的gradle定义动态属性时，不需要加ext关键字的。

对于Project和Task而言，动态属性定义的方式完全一样，只是作用域不一样。
当定义完成后，我们就可以使用project.prop 或者 task.prop来访问这些动态属性了。下面让我们看一个例子： 

	ext.projectProperties="ext projectProperties-value"
	task printExtProps << {
	  ext.taskProperties="ext.task.properties-value"
	  if (project.hasProperty('projectProperties')){
	    println "ext.projectProperties values is " + projectProperties  
	  }
	  if (printExtProps.hasProperty('taskProperties')){
	    println "task has defined ext.taskProperties value is " + taskProperties  
	  }
	}
注意：，对于ext定义的动态属性，并不能通过外部的方式修改它的值，只能在build.gradle中去设置或者修改它的值。

同时，如果是为project定义的ext动态属性，也会显示在gradle properties的结果中。

###3. Task依赖

当构建一个复杂的项目时，不同task之间存在依赖是必然的。比如说，如果想运行'部署'的task，必然要先运行 编译、打包、检测服务器等task，只有当这被些被依赖的task执行完成后，才会部署。对于这种行为之间的依赖，Ant、Maven都提供了声明式的定义，非常简单。同样，使用Gradle定义task之间的依赖也是件很容易的事。

例如，定义如下两个Task，并且在"intro"里加上"dependendsOn"的关键字，如下所示：

	task hello << {
	    println 'Hello world!'
	}
	task intro(dependsOn: hello) << {
	    println "I'm Gradle" 
	}
执行 "gradle intro"，结果将是:
	Hello World
	I'm Gradle
由此可见，当执行gradle intro时，intro依赖的task hello会先被执行。除此之外，dependensOn也支持定义多个task的依赖，使用[]括起来即可。例如

	task A(dependensOn:['B','C','D']) <<{ xxx }
除了使用dependensOn跟字符串来定义依赖，我们也可以使用taskX.dependensOn taskY这种形式：

	task taskX << {
	    println 'taskX'
	}
	task taskY << {
	    println 'taskY'
	} 
	taskX.dependsOn taskY

或者，也可以使用闭包：

	task taskX << {
	    println 'taskX'
	}
	taskX.dependsOn {
	    tasks.findAll { task -> task.name.startsWith('lib') }
	}
	task lib1 << {
	    println 'lib1'
	}
除了之前讲的task的部分，Gradle还为我们提供了很多可用的API，更多的细节大家可以参考下Gradle的文档。这里我列出一个常用的方法onlyIf。在Gradle里，我们可以使用“OnlyIf()”来决定当前task是否需要被执行，例如：新建build.gradle，加入如下代码：

	task hello << {
	    println 'hello world'
	} 
	hello.onlyIf { !project.hasProperty('skipHello') }

当我们直接执行"gradle hello"时，没有任何结果，当我们执行"gradle hello -PskipHello=xxxx"时，会输出"hello world"。

###4. 总结
OK.今天对gradle的总结到此为止。总体而言，用DSL的代码而不是xml来定义构建的过程，还是很fancy的。
